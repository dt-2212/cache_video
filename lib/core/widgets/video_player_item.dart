import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/app_data_controller.dart';
import '../models/video.dart';
import '../services/precache_manager.dart';

/// A single full-screen video page with the TikTok-style overlays.
///
/// Plays only while [isActive] is true (current page of the active tab),
/// streams through the on-disk HLS cache, and pauses on app backgrounding.
class VideoPlayerItem extends StatefulWidget {
  final Video video;
  final bool isActive;
  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.isActive,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with WidgetsBindingObserver {
  final AppDataController _data = Get.find();
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _appActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeController();
  }

  Future<void> _initializeController() async {
    final url = widget.video.url;
    debugPrint('🎬 init START "${widget.video.title}" '
        'live=${widget.video.isLive} url=$url');
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions:
          PreCacheManager.optionsFor(url, live: widget.video.isLive),
    );
    // Surface every controller state change while initialize() is pending,
    // so a hang vs. a buffering/error state is visible in the logs.
    _controller.addListener(_logValue);
    final sw = Stopwatch()..start();
    try {
      // Bound the wait so a dead/blocked stream stops at an error instead of
      // spinning forever.
      await _controller.initialize().timeout(const Duration(seconds: 15));
      debugPrint('🎬 init OK   "${widget.video.title}" '
          'in ${sw.elapsedMilliseconds}ms size=${_controller.value.size} '
          'duration=${_controller.value.duration}');
      if (mounted) {
        setState(() => _isInitialized = true);
        _controller.setLooping(true);
        _syncPlayback();
      }
    } catch (e) {
      debugPrint('🎬 init FAIL "${widget.video.title}" '
          'after ${sw.elapsedMilliseconds}ms err=$e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  /// Logs notable controller-state transitions (avoids per-frame spam).
  String _lastValueLog = '';
  void _logValue() {
    final v = _controller.value;
    final snapshot = 'initialized=${v.isInitialized} buffering=${v.isBuffering} '
        'playing=${v.isPlaying} hasError=${v.hasError}';
    if (snapshot == _lastValueLog) return;
    _lastValueLog = snapshot;
    debugPrint('🎬 state "${widget.video.title}" $snapshot'
        '${v.hasError ? ' errorDesc=${v.errorDescription}' : ''}');
  }

  /// Play only when this page is active *and* the app is foregrounded.
  void _syncPlayback() {
    if (!_isInitialized) return;
    final shouldPlay = widget.isActive && _appActive;
    if (shouldPlay && !_controller.value.isPlaying) {
      debugPrint('🎬 play  "${widget.video.title}"');
      _controller.play();
      // markWatched mutates a GetX observable. _syncPlayback can run mid-build
      // (e.g. from didUpdateWidget when the active page changes), and writing an
      // observable during build throws "setState() called during build". Defer
      // it to after the current frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _data.markWatched(widget.video.id);
      });
    } else if (!shouldPlay && _controller.value.isPlaying) {
      debugPrint('🎬 pause "${widget.video.title}"');
      _controller.pause();
    }
  }

  @override
  void didUpdateWidget(VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) _syncPlayback();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appActive = state == AppLifecycleState.resumed;
    if (_appActive) _controller.restorePlayerSurface();
    _syncPlayback();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_logValue);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    return Stack(
      children: [
        Positioned.fill(
          child: _isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Container(
                  color: video.thumbColor.withValues(alpha: 0.25),
                  alignment: Alignment.center,
                  child: _hasError
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.white70, size: 48),
                            const SizedBox(height: 8),
                            Text(
                              'Stream unavailable\n${video.title}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(color: Colors.white),
                ),
        ),

        // Gradient overlay for legibility.
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: const [0.0, 0.2, 0.8, 1.0],
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _togglePlay,
          ),
        ),

        // Right-side action rail.
        Positioned(
          right: 12,
          bottom: 96,
          child: Column(
            children: [
              Obx(
                () => _ActionButton(
                  icon: _data.isLiked(video.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: video.likesLabel,
                  color: _data.isLiked(video.id) ? Colors.red : Colors.white,
                  onTap: () => _data.toggleLike(video.id),
                ),
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.comment,
                label: video.commentsLabel,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.share,
                label: video.sharesLabel,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              _buildMusicDisc(video),
            ],
          ),
        ),

        // Author + caption info.
        Positioned(
          left: 16,
          bottom: 40,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.author,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                video.caption,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      video.music,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (_isInitialized && !_controller.value.isPlaying)
          const Center(
            child: Icon(Icons.play_arrow, color: Colors.white70, size: 72),
          ),
      ],
    );
  }

  Widget _buildMusicDisc(Video video) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            video.thumbColor,
            Colors.grey[900]!,
            Colors.black,
            video.thumbColor,
          ],
        ),
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.music_note, color: Colors.white, size: 24),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
