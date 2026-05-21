import 'package:flutter/material.dart';
import '../models/video.dart';

/// Poster-style thumbnail used by the Home rails and grids (drama-app look).
class PosterTile extends StatelessWidget {
  final Video video;
  final double width;
  final double height;
  final VoidCallback onTap;
  final bool showTitle;

  const PosterTile({
    super.key,
    required this.video,
    required this.onTap,
    this.width = 130,
    this.height = 190,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      video.thumbColor,
                      video.thumbColor.withValues(alpha: 0.5),
                      Colors.black,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(Icons.play_circle_fill,
                          color: Colors.white70, size: 36),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video.category,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Row(
                        children: [
                          const Icon(Icons.play_arrow,
                              color: Colors.white, size: 13),
                          const SizedBox(width: 2),
                          Text(
                            video.viewsLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showTitle) ...[
              const SizedBox(height: 6),
              Text(
                video.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
