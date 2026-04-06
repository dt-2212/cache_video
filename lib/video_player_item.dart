import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerItem extends StatefulWidget {
  final String url;
  final bool isActive;
  const VideoPlayerItem({super.key, required this.url, required this.isActive});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late final Player player;
  late final VideoController controller;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);

    // Tinh chỉnh nhân MPV để vượt qua lỗi đồ họa trên Emulator
    try {
      if (player.platform is dynamic) {
        (player as dynamic).setProperty('hwdec', 'no'); // Tắt giải mã phần cứng
        (player as dynamic).setProperty('vo', 'gpu');
        (player as dynamic).setProperty('gpu-context', 'android');
      }
    } catch (e) {
      debugPrint('Lỗi cấu hình MPV: $e');
    }
    
    // Debug logging for player state
    _subscriptions.add(player.stream.error.listen((error) {
      debugPrint('MediaKit Error: $error');
    }));

    _subscriptions.add(player.stream.completed.listen((completed) {
      if (completed) {
        debugPrint('Playback completed');
      }
    }));

    player.open(
      Media(widget.url),
      play: widget.isActive,
    );
    player.setPlaylistMode(PlaylistMode.loop);
  }

  @override
  void didUpdateWidget(VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      debugPrint('Activating video: ${widget.url}');
      player.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      debugPrint('Pausing video: ${widget.url}');
      player.pause();
    }
  }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Player
        Positioned.fill(
          child: Video(
            controller: controller,
            fill: Colors.black,
            alignment: Alignment.center,
            fit: BoxFit.cover,
            controls: NoVideoControls,
          ),
        ),
        
        // Buffering Indicator
        StreamBuilder<bool>(
          stream: player.stream.buffering,
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
                stops: const [0.0, 0.2, 0.8, 1.0],
              ),
            ),
          ),
        ),

        // UI Overlays
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            children: [
              _buildIconButton(Icons.favorite, "1.2M", Colors.red),
              const SizedBox(height: 20),
              _buildIconButton(Icons.comment, "12.5K", Colors.white),
              const SizedBox(height: 20),
              _buildIconButton(Icons.share, "Share", Colors.white),
              const SizedBox(height: 20),
              _buildMusicDisc(),
            ],
          ),
        ),

        // Info Overlay
        Positioned(
          left: 16,
          bottom: 40,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "@official_videos",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Check out this amazing content! #video #trending #foryou",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
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
                      "Original Sound - Video Studio",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
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

        // Tap to Play/Pause
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (player.state.playing) {
                player.pause();
              } else {
                player.play();
              }
            },
          ),
        ),

        // Error log display (Optional - for debugging on emulator)
        StreamBuilder(
          stream: player.stream.error,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Error: ${snapshot.data}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String label, Color color) {
    return Column(
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
    );
  }

  Widget _buildMusicDisc() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Colors.grey[800]!,
            Colors.grey[900]!,
            Colors.black,
            Colors.grey[800]!,
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
