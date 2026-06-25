import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

/// Centralised HLS cache configuration + preloading, modelled on the drama app.
///
/// Uses the forked `video_player` API (`hlsCacheConfig`, `preCache`) so that
/// streamed segments are cached on disk and the next reel starts instantly.
class PreCacheManager {
  PreCacheManager._();

  /// Number of upcoming reels to warm up when a feed first loads.
  static const int prefetchCount = 3;

  /// 512 MB on-disk cache shared across all videos (field is a double).
  static const double _maxCacheSize = 512 * 1024 * 1024.0;

  static const _buffering = BufferingConfig(minBufferMs: 3000, maxBufferMs: 5000);

  /// The fork's HLS cache proxy never initialises on the iOS Simulator
  /// (`initialize()` hangs forever), so disk caching is disabled there and we
  /// stream directly. On real devices it stays on. Resolved by [init].
  static bool _isSimulator = false;
  static bool get diskCacheSupported => !_isSimulator;

  /// Detect the iOS Simulator once at startup. Call before any playback.
  static Future<void> init() async {
    if (Platform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      _isSimulator = !info.isPhysicalDevice;
    }
    debugPrint('🎬 PreCacheManager init isSimulator=$_isSimulator '
        'diskCacheSupported=$diskCacheSupported');
  }

  /// Whether to use the on-disk cache for a stream. Live streams are never
  /// cached — they are endless, so there is nothing to cache to disk.
  static bool useCacheFor({required bool live}) => diskCacheSupported && !live;

  /// Build the player options for a given [url]. The [url] doubles as cache key
  /// so the same stream is reused whether it was preloaded or played directly.
  static VideoPlayerOptions optionsFor(String url, {bool live = false}) {
    final cache = useCacheFor(live: live);
    debugPrint('🎬 optionsFor useCache=$cache live=$live url=$url');
    if (!cache) {
      return VideoPlayerOptions(mixWithOthers: true, bufferingConfig: _buffering);
    }
    return VideoPlayerOptions(
      mixWithOthers: true,
      hlsCacheConfig: HlsCacheConfig(
        useCache: true,
        cacheKey: url,
        maxCacheSize: _maxCacheSize,
      ),
      bufferingConfig: _buffering,
    );
  }

  /// Warm the cache for [url] without creating a visible player. Skipped when
  /// caching is unavailable (simulator) or for live streams.
  static void preCache(String url, {bool live = false}) {
    if (url.isEmpty) return;
    if (!useCacheFor(live: live)) {
      debugPrint('🎬 preCache SKIP (no cache) live=$live $url');
      return;
    }
    debugPrint('🎬 preCache $url');
    VideoPlayerController.preCache(url, videoPlayerOptions: optionsFor(url, live: live));
  }
}
