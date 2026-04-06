import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'video_provider.dart';
import 'video_player_item.dart';

class VideoScrollingScreen extends ConsumerWidget {
  const VideoScrollingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoUrls = ref.watch(videoUrlsProvider);
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        // Removed itemCount for infinite scrolling
        onPageChanged: (index) {
          ref.read(currentIndexProvider.notifier).set(index);
        },
        itemBuilder: (context, index) {
          // Use modulo to cycle through video URLs
          final actualIndex = index % videoUrls.length;
          return VideoPlayerItem(
            url: videoUrls[actualIndex],
            isActive: index == currentIndex,
          );
        },
      ),
    );
  }
}
