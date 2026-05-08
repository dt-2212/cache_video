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

  /// Build the cache options for a given [url]. The [url] doubles as cache key
  /// so the same stream is reused whether it was preloaded or played directly.
  static VideoPlayerOptions optionsFor(String url) => VideoPlayerOptions(
        mixWithOthers: true,
        hlsCacheConfig: HlsCacheConfig(
          useCache: true,
          cacheKey: url,
          maxCacheSize: _maxCacheSize,
        ),
        bufferingConfig: const BufferingConfig(
          minBufferMs: 3000,
          maxBufferMs: 5000,
        ),
      );

  /// Warm the cache for [url] without creating a visible player.
  static void preCache(String url) {
    if (url.isEmpty) return;
    VideoPlayerController.preCache(url, videoPlayerOptions: optionsFor(url));
  }
}
