import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';
import '../../feed/views/feed_viewer_screen.dart';
import '../../../core/widgets/poster_tile.dart';

/// Grid tab displaying a list of videos or an empty state message in the Library screen.
class VideoGridTab extends StatelessWidget {
  final List<Video> videos;
  final String emptyText;

  const VideoGridTab({
    super.key,
    required this.videos,
    required this.emptyText,
  });

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
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 70),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return PosterTile(
          video: video,
          width: double.infinity,
          height: 150,
          onTap: () {
            if (video.isLive) {
              openFeed([video], 0);
            } else {
              final allEpisodes = Get.find<AppDataController>()
                  .getEpisodesForSeries(video.author);
              final epIndex = allEpisodes.indexWhere((v) => v.id == video.id);
              openFeed(allEpisodes, epIndex >= 0 ? epIndex : 0);
            }
          },
        );
      },
    );
  }
}
