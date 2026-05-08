import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/precache_manager.dart';
import 'video_player_item.dart';

/// Vertical, continuously-scrolling video feed (TikTok-style) with preloading.
///
/// Pass [isActive] = false when the owning tab is not visible so playback
/// pauses. Set [loop] for an endless feed that cycles the list.
class VideoFeed extends StatefulWidget {
  final List<Video> videos;
  final bool isActive;
  final int initialIndex;
  final bool loop;

  const VideoFeed({
    super.key,
    required this.videos,
    this.isActive = true,
    this.initialIndex = 0,
    this.loop = true,
  });

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
    _warmUpCache();
  }

  /// Preload the first few upcoming reels so the feed starts instantly.
  void _warmUpCache() {
    final count = widget.videos.length;
    if (count == 0) return;
    for (var i = 0; i < PreCacheManager.prefetchCount; i++) {
      PreCacheManager.preCache(widget.videos[(_currentIndex + i) % count].url);
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    final count = widget.videos.length;
    if (count == 0) return;
    // Preload the next reel as soon as the current one is shown.
    PreCacheManager.preCache(widget.videos[(index + 1) % count].url);
  }

  @override
  void dispose() {
    _controller.dispose();
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
          isActive: widget.isActive && index == _currentIndex,
        );
      },
    );
  }
}
