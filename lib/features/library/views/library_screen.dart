import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';
import '../../../core/widgets/feed_viewer_screen.dart';
import '../../../core/widgets/poster_tile.dart';
import '../controllers/library_controller.dart';

/// Library = "My List": Favorites + Watch History, drama-app style.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LibraryController>();
    final data = Get.find<AppDataController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('My List'),
          centerTitle: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Favorites'),
              Tab(text: 'History'),
            ],
          ),
        ),
        // Rebuild when likes / history change.
        body: Obx(() {
          // Touch observables so Obx tracks them.
          data.liked.length;
          data.history.length;
          return TabBarView(
            children: [
              _VideoGridTab(
                videos: controller.favorites,
                emptyText: 'No favorites yet.\nTap ❤ on a video to save it.',
              ),
              _VideoGridTab(
                videos: controller.history,
                emptyText: 'Nothing watched yet.',
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _VideoGridTab extends StatelessWidget {
  final List<Video> videos;
  final String emptyText;
  const _VideoGridTab({required this.videos, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) => PosterTile(
        video: videos[index],
        width: double.infinity,
        height: 150,
        onTap: () => openFeed(videos, index),
      ),
    );
  }
}
