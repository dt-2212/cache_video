import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/video.dart';
import 'm3u_parser.dart';

/// A titled group of live channels (maps 1:1 to a Home rail).
class ChannelGroup {
  final String title;
  final List<Video> channels;
  const ChannelGroup(this.title, this.channels);
}

/// Fetches live-TV channels from the public iptv-org playlists and maps each
/// channel to the app's [Video] model so the existing Home UI can render them.
abstract class IptvService {
  static const String _base = 'https://iptv-org.github.io/iptv/categories';

  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    // Playlists are plain text; take the raw body without JSON decoding.
    responseType: ResponseType.plain,
  ));

  /// Categories pulled for the Home rails (each becomes one rail). Order here
  /// is the order shown on screen.
  static const List<String> categories = [
    'news',
    'movies',
    'entertainment',
    'sports',
    'music',
    'documentary',
  ];

  /// Max channels kept per rail — the raw category playlists hold hundreds.
  static const int _perCategory = 25;

  /// Accent palette reused for placeholder gradients behind channel logos.
  static const List<Color> _palette = [
    Color(0xFF8E2DE2),
    Color(0xFF00B4DB),
    Color(0xFFFF512F),
    Color(0xFF11998E),
    Color(0xFFFC466B),
    Color(0xFF2193B0),
  ];

  /// Fetch all configured categories in parallel. Categories that fail (network
  /// error / empty) are skipped so one bad list doesn't break the whole page.
  static Future<List<ChannelGroup>> fetchGroups() async {
    final results = await Future.wait(
      categories.map(_fetchCategory),
      eagerError: false,
    );
    return [
      for (final g in results)
        if (g != null && g.channels.isNotEmpty) g,
    ];
  }

  static Future<ChannelGroup?> _fetchCategory(String category) async {
    try {
      final res = await _dio.get<String>('$_base/$category.m3u');
      final body = res.data;
      if (res.statusCode != 200 || body == null || body.isEmpty) return null;

      final entries = M3uParser.parse(body);
      final channels = <Video>[];
      for (var i = 0; i < entries.length && channels.length < _perCategory; i++) {
        channels.add(_toVideo(entries[i], category, channels.length));
      }
      return ChannelGroup(_titleFor(category), channels);
    } catch (_) {
      return null;
    }
  }

  static Video _toVideo(M3uEntry e, String category, int index) {
    return Video(
      // Stream URL is unique + stable, so it doubles as the like/history key.
      id: e.url,
      url: e.url,
      title: e.name,
      category: _titleFor(category),
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

  static String _titleFor(String category) =>
      category.isEmpty ? 'Live' : category[0].toUpperCase() + category.substring(1);
}
