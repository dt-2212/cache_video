import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/video.dart';
import '../routes/app_routes.dart';
import 'video_feed.dart';

/// Arguments passed to the [FeedViewerScreen] route.
class FeedArgs {
  final List<Video> videos;
  final int initialIndex;
  const FeedArgs(this.videos, this.initialIndex);
}

/// Full-screen feed pushed as its own route (e.g. from Home/Library grids).
class FeedViewerScreen extends StatelessWidget {
  const FeedViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as FeedArgs;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          VideoFeed(
            videos: args.videos,
            initialIndex: args.initialIndex,
            loop: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back<void>(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the given list as a full-screen vertical feed starting at [index].
void openFeed(List<Video> videos, int index) {
  Get.toNamed<void>(Routes.feed, arguments: FeedArgs(videos, index));
}
