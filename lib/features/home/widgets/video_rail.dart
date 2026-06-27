import 'package:flutter/material.dart';
import '../../../core/models/video.dart';
import '../../../core/widgets/feed_viewer_screen.dart';
import '../../../core/widgets/poster_tile.dart';

/// Horizontal rail displaying a category of videos on the Home screen.
class VideoRail extends StatelessWidget {
  final String title;
  final List<Video> videos;

  const VideoRail({
    super.key,
    required this.title,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 222,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: videos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) =>
                PosterTile(video: videos[i], onTap: () => openFeed(videos, i)),
          ),
        ),
      ],
    );
  }
}
