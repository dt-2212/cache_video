import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/video.dart';
import '../services/precache_manager.dart';
import 'video_player_item.dart';

/// Vertical, continuously-scrolling video feed (TikTok-style) with preloading.
///
/// Pass [isActive] = false when the owning tab is not visible so playback
/// pauses. Set [loop] for an endless feed that cycles the list.
/// Provide [controller] to control page jumps externally.
/// [onEpisodesTap] overrides the EP button behavior per-item.
class VideoFeed extends StatefulWidget {
  final List<Video> videos;
  final bool isActive;
  final int initialIndex;
  final bool loop;
  final PageController? controller;
  final void Function(Video)? onEpisodesTap;

  const VideoFeed({
    super.key,
    required this.videos,
    this.isActive = true,
    this.initialIndex = 0,
    this.loop = true,
    this.controller,
    this.onEpisodesTap,
  });

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  late final PageController _controller;
  late final RxInt _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.obs;
    _controller =
        widget.controller ?? PageController(initialPage: widget.initialIndex);
    _preCacheAround(_currentIndex.value);
  }

  /// Preload the current reel, plus neighboring reels (before and after) so scrolling in either direction is instant.
  void _preCacheAround(int index) {
    final count = widget.videos.length;
    if (count == 0 || index < 0 || index >= count) return;

    final indices = <int>{};
    indices.add(index);

    // Cache next 2 videos
    for (var i = 1; i <= 2; i++) {
      final target = index + i;
      if (widget.loop) {
        indices.add(target % count);
      } else {
        if (target >= 0 && target < count) {
          indices.add(target);
        }
      }
    }

    // Cache previous 2 videos
    for (var i = 1; i <= 2; i++) {
      final target = index - i;
      if (widget.loop) {
        indices.add((target % count + count) % count);
      } else {
        if (target >= 0 && target < count) {
          indices.add(target);
        }
      }
    }

    debugPrint('📺 VideoFeed preCacheAround index=$index indices=$indices');
    for (final idx in indices) {
      if (idx >= 0 && idx < widget.videos.length) {
        final v = widget.videos[idx];
        PreCacheManager.preCache(v.url, live: v.isLive);
      }
    }
  }

  void _onPageChanged(int index) {
    debugPrint('📺 VideoFeed page -> $index');
    _currentIndex.value = index;
    _preCacheAround(index);
  }

  @override
  void dispose() {
    // Only dispose if we created the controller ourselves.
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.videos.length;
    if (count == 0) {
      return const Center(
        child: Text('No videos', style: TextStyle(color: Colors.white54)),
      );
    }

    return Obx(() {
      // Read here so Obx tracks the subscription; pass as captured local
      // into itemBuilder which is called lazily outside Obx's build scope.
      final current = _currentIndex.value;
      return PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: widget.loop ? null : count,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final video = widget.videos[index % count];
          return VideoPlayerItem(
            key: ValueKey('${video.id}_$index'),
            video: video,
            isActive: widget.isActive && index == current,
            onEpisodesTap: widget.onEpisodesTap,
          );
        },
      );
    });
  }
}
