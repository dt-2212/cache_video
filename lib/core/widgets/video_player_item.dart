import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/app_data_controller.dart';
import '../models/video.dart';
import '../services/precache_manager.dart';

/// A single full-screen video page with the TikTok-style overlays.
///
/// Plays only while [isActive] is true (current page of the active tab),
/// streams through the on-disk HLS cache, and pauses on app backgrounding.
///
/// [onEpisodesTap] handles the EP button tap.
/// When null the button is a no-op — callers must provide the callback.
class VideoPlayerItem extends StatefulWidget {
  final Video video;
  final bool isActive;
  final void Function(Video)? onEpisodesTap;
  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.isActive,
    this.onEpisodesTap,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with WidgetsBindingObserver {
  final AppDataController _data = Get.find();
  late VideoPlayerController _controller;
  final _isInitialized = false.obs;
  final _hasError = false.obs;
  final _isPlaying = false.obs;
  bool _appActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeController();
  }

  Future<void> _initializeController() async {
    final url = widget.video.url;
    debugPrint(
      '🎬 init START "${widget.video.title}" '
      'live=${widget.video.isLive} url=$url',
    );
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: PreCacheManager.optionsFor(
        url,
        live: widget.video.isLive,
      ),
    );
    // Surface every controller state change while initialize() is pending,
    // so a hang vs. a buffering/error state is visible in the logs.
    _controller.addListener(_logValue);
    final sw = Stopwatch()..start();
    try {
      // Bound the wait so a dead/blocked stream stops at an error instead of
      // spinning forever.
      await _controller.initialize().timeout(const Duration(seconds: 15));
      debugPrint(
        '🎬 init OK   "${widget.video.title}" '
        'in ${sw.elapsedMilliseconds}ms size=${_controller.value.size} '
        'duration=${_controller.value.duration}',
      );
      if (mounted) {
        _isInitialized.value = true;
        _controller.setLooping(true);
        _syncPlayback();
      }
    } catch (e) {
      debugPrint(
        '🎬 init FAIL "${widget.video.title}" '
        'after ${sw.elapsedMilliseconds}ms err=$e',
      );
      if (mounted) _hasError.value = true;
    }
  }

  /// Logs notable controller-state transitions (avoids per-frame spam).
  String _lastValueLog = '';
  void _logValue() {
    final v = _controller.value;
    _isPlaying.value = v.isPlaying; // Keep reactive state in sync
    final snapshot =
        'initialized=${v.isInitialized} buffering=${v.isBuffering} '
        'playing=${v.isPlaying} hasError=${v.hasError}';
    if (snapshot == _lastValueLog) return;
    _lastValueLog = snapshot;
    debugPrint(
      '🎬 state "${widget.video.title}" $snapshot'
      '${v.hasError ? ' errorDesc=${v.errorDescription}' : ''}',
    );
  }

  /// Play only when this page is active *and* the app is foregrounded.
  void _syncPlayback() {
    if (!_isInitialized.value) return;
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
      _isPlaying.value = false;
    } else {
      _controller.play();
      _isPlaying.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final bottomOffset = 60.h + (bottomInset > 0 ? bottomInset * 0.35 : 0.0);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: Obx(
              () => _isInitialized.value
                  ? FittedBox(
                      fit: BoxFit.contain,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : Center(
                      child: _hasError.value
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.white70,
                                  size: 48.r,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Stream unavailable\n${video.title}',
                                  textAlign: TextAlign.center,
                                  style:
                                      const TextStyle(color: Colors.white70),
                                ),
                              ],
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white),
                    ),
            ),
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
          right: 12.w,
          bottom: bottomOffset + 36.h,
          child: Column(
            children: [
              Obx(
                () => _ActionButton(
                  icon: _data.isLiked(video.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _data.isLiked(video.id) ? Colors.red : Colors.white,
                  onTap: () => _data.toggleLike(video.id),
                ),
              ),
              SizedBox(height: 20.h),
              _ActionButton(icon: Icons.share, color: Colors.white),
              if (!video.isLive) ...[
                SizedBox(height: 20.h),
                _EpisodeListButton(
                  onTap: () => widget.onEpisodesTap?.call(video),
                ),
              ],
            ],
          ),
        ),

        // Author + caption info.
        Positioned(
          left: 16.w,
          bottom: bottomOffset + 4.h,
          right: 80.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.author,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                video.caption,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 16.r),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      video.music,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Obx(
          () => _isInitialized.value && !_isPlaying.value
              ? Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white70,
                    size: 72.r,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _ActionButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 32.r),
    );
  }
}

/// Button on the right action rail that opens the full episode list.
class _EpisodeListButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EpisodeListButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.playlist_play_rounded,
              color: Colors.white,
              size: 22.r,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Tập',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
