import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/video.dart';
import '../theme/app_colors.dart';

/// Returns the 1–2 letter monogram for a series name.
String seriesInitials(String name) {
  final parts = name.split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
}

/// Shows a draggable bottom sheet listing [episodes] for a series.
/// [onEpisodeTap] receives the 0-based index of the tapped episode.
void showEpisodeListSheet(
  BuildContext context,
  List<Video> episodes,
  Color accentColor, {
  required void Function(int index) onEpisodeTap,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _EpisodeListSheet(
      episodes: episodes,
      accentColor: accentColor,
      onEpisodeTap: onEpisodeTap,
    ),
  );
}

class _EpisodeListSheet extends StatelessWidget {
  final List<Video> episodes;
  final Color accentColor;
  final void Function(int index) onEpisodeTap;

  const _EpisodeListSheet({
    required this.episodes,
    required this.accentColor,
    required this.onEpisodeTap,
  });

  @override
  Widget build(BuildContext context) {
    final seriesName = episodes.isNotEmpty ? episodes.first.author : '';

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        seriesInitials(seriesName),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seriesName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${episodes.length} tập',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.07)),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: episodes.length,
                itemBuilder: (context, i) => EpisodeTile(
                  episode: episodes[i],
                  number: i + 1,
                  accentColor: accentColor,
                  onTap: () {
                    Navigator.of(context).pop();
                    onEpisodeTap(i);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable episode row — used by [showEpisodeListSheet] and [EpisodeListScreen].
class EpisodeTile extends StatelessWidget {
  final Video episode;
  final int number;
  final Color accentColor;
  final VoidCallback onTap;

  const EpisodeTile({
    super.key,
    required this.episode,
    required this.number,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                episode.title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.play_circle_outline_rounded,
              color: AppColors.textMuted,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}
