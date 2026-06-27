import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/video.dart';
import '../theme/app_colors.dart';
import 'channel_source.dart';
import 'm3u_parser.dart';

/// A titled group of live channels (maps 1:1 to a Home rail).
class ChannelGroup {
  final String title;
  final List<Video> channels;
  const ChannelGroup(this.title, this.channels);
}

/// Fetches live-TV channels from the configured [channelSources] and maps each
/// channel to the app's [Video] model so the existing Home UI can render them.
///
/// The service is provider-agnostic: it only knows how to download and parse
/// extended-M3U playlists. Which playlists to use lives in [channelSources].
abstract class ChannelService {
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    // Playlists are plain text; take the raw body without JSON decoding.
    responseType: ResponseType.plain,
  ));

  /// Probe each stream and drop the ones that don't actually play. Adds a few
  /// seconds to the first load; set false to show channels unverified.
  static const bool validateStreams = true;

  /// Parallel stream checks in flight at once.
  static const int _maxConcurrentChecks = 24;

  /// Per-request budget for a validation probe.
  static const Duration _checkTimeout = Duration(seconds: 5);

  /// Accent palette reused for placeholder gradients behind channel logos.
  static const List<Color> _palette = [
    AppColors.accent,
    AppColors.cyan,
    AppColors.coral,
    AppColors.mint,
    AppColors.pink,
    AppColors.skyBlue,
  ];

  /// Fetch all sources (fast, unvalidated). Validation runs separately via
  /// [playableUrls] so the UI can show channels immediately and prune dead ones
  /// in the background. Sources that fail to download are skipped.
  static Future<List<ChannelGroup>> fetchGroups() async {
    debugPrint('🌐 fetchGroups START sources=${channelSources.length}');
    final sw = Stopwatch()..start();
    final raw = await Future.wait(channelSources.map(_fetchSource),
        eagerError: false);
    final groups = [
      for (final list in raw)
        for (final g in list)
          if (g.channels.isNotEmpty) g,
    ];
    final total = groups.fold<int>(0, (s, g) => s + g.channels.length);
    debugPrint('🌐 fetchGroups DONE in ${sw.elapsedMilliseconds}ms '
        'groups=${groups.length} channels=$total');
    return groups;
  }

  /// Probe [channels] in parallel and return the URLs that actually play.
  /// Runs the two-level HLS check with a bounded worker pool.
  static Future<Set<String>> playableUrls(Iterable<Video> channels) async {
    final candidates = channels.toList();
    final sw = Stopwatch()..start();
    final ok = await _keepPlayable(candidates);
    debugPrint('🌐 validate: ${ok.length}/${candidates.length} playable '
        'in ${sw.elapsedMilliseconds}ms');
    return ok;
  }

  /// Download + parse one [source] into one or more (unvalidated) rails.
  static Future<List<ChannelGroup>> _fetchSource(ChannelSource source) async {
    try {
      final res = await _dio.get<String>(source.url);
      final body = res.data;
      debugPrint('🌐 [${source.title}] HTTP ${res.statusCode} '
          'bytes=${body?.length ?? 0}');
      if (res.statusCode != 200 || body == null || body.isEmpty) return const [];

      final entries = M3uParser.parse(body);
      final groups = source.splitByGroup
          ? _splitByGroup(entries, source)
          : _singleRail(entries, source);
      final total = groups.fold<int>(0, (s, g) => s + g.channels.length);
      debugPrint('🌐 [${source.title}] parsed=${entries.length} '
          'rails=${groups.length} candidates=$total');
      return groups;
    } catch (e) {
      debugPrint('🌐 [${source.title}] ERROR $e');
      return const [];
    }
  }

  /// Whole playlist → one rail, capped at [ChannelSource.limitPerRail].
  static List<ChannelGroup> _singleRail(
      List<M3uEntry> entries, ChannelSource source) {
    final channels = <Video>[];
    for (var i = 0;
        i < entries.length && channels.length < source.limitPerRail;
        i++) {
      channels.add(_toVideo(entries[i], source.title, channels.length));
    }
    return [ChannelGroup(source.title, channels)];
  }

  /// Playlist → one rail per `group-title`, in first-seen order, capped at
  /// [ChannelSource.maxRails] rails and [ChannelSource.limitPerRail] channels.
  static List<ChannelGroup> _splitByGroup(
      List<M3uEntry> entries, ChannelSource source) {
    final order = <String>[];
    final buckets = <String, List<Video>>{};
    for (final e in entries) {
      final title = (e.group == null || e.group!.isEmpty)
          ? source.title
          : e.group!;
      final bucket = buckets.putIfAbsent(title, () {
        order.add(title);
        return <Video>[];
      });
      if (bucket.length < source.limitPerRail) {
        bucket.add(_toVideo(e, title, bucket.length));
      }
    }
    return [
      for (final title in order.take(source.maxRails))
        ChannelGroup(title, buckets[title]!),
    ];
  }

  /// Returns the set of URLs (from [candidates]) that are playable, checked
  /// concurrently with a bounded worker pool.
  static Future<Set<String>> _keepPlayable(List<Video> candidates) async {
    final ok = <String>{};
    final it = candidates.iterator;
    // moveNext()+current run synchronously before any await, so no two workers
    // ever pull the same element.
    Future<void> worker() async {
      while (it.moveNext()) {
        final v = it.current;
        if (await _isPlayable(v.url)) ok.add(v.url);
      }
    }

    await Future.wait(List.generate(_maxConcurrentChecks, (_) => worker()));
    return ok;
  }

  /// A channel is playable when its master playlist loads and resolves to a
  /// media playlist that has segments. For a master, the first variant is
  /// fetched too (catches "master OK but variant 404" cases).
  static Future<bool> _isPlayable(String url) async {
    final master = await _probe(url);
    if (master == null || !master.contains('#EXTM3U')) return false;

    // Already a media playlist (has segments directly).
    if (!master.contains('#EXT-X-STREAM-INF')) return master.contains('#EXTINF');

    final variant = _firstVariantUrl(master, url);
    if (variant == null) return false;
    final body = await _probe(variant);
    return body != null && body.contains('#EXTINF');
  }

  /// GET the first bytes of [url]; returns the body for 200/206, else null.
  static Future<String?> _probe(String url) async {
    try {
      final res = await _dio
          .get<String>(
            url,
            options: Options(
              headers: {'Range': 'bytes=0-65535'},
              receiveTimeout: _checkTimeout,
              sendTimeout: _checkTimeout,
            ),
          )
          .timeout(_checkTimeout + const Duration(seconds: 1));
      if (res.statusCode == 200 || res.statusCode == 206) return res.data ?? '';
      return null;
    } catch (_) {
      return null;
    }
  }

  /// First variant stream URL in a master playlist, resolved against [baseUrl].
  static String? _firstVariantUrl(String master, String baseUrl) {
    final lines = master.split('\n');
    for (var i = 0; i < lines.length; i++) {
      if (!lines[i].trim().startsWith('#EXT-X-STREAM-INF')) continue;
      for (var j = i + 1; j < lines.length; j++) {
        final l = lines[j].trim();
        if (l.isEmpty || l.startsWith('#')) continue;
        return Uri.parse(baseUrl).resolve(l).toString();
      }
    }
    return null;
  }

  static Video _toVideo(M3uEntry e, String railTitle, int index) {
    return Video(
      // Stream URL is unique + stable, so it doubles as the like/history key.
      id: e.url,
      url: e.url,
      title: e.name,
      category: railTitle,
      author: e.name,
      caption: e.name,
      music: 'Live broadcast',
      likes: 0,
      comments: 0,
      shares: 0,
      views: 0,
      thumbColor: _palette[index % _palette.length],
      logoUrl: e.logo,
      isLive: true,
    );
  }
}
