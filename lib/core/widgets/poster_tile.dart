import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../models/video.dart';
import '../theme/app_colors.dart';
import '../controllers/app_data_controller.dart';

/// Poster-style thumbnail — streaming-app aesthetic (Netflix/Disney+ style).
class PosterTile extends StatelessWidget {
  final Video video;
  final double width;
  final double height;
  final VoidCallback onTap;

  const PosterTile({
    super.key,
    required this.video,
    required this.onTap,
    this.width = 130,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    final data = Get.find<AppDataController>();
    final epCount = video.isLive
        ? 0
        : data.getEpisodesForSeries(video.author).length;

    final words = (video.isLive ? video.title : video.author).split(' ');
    String initials = '';
    if (words.isNotEmpty && words[0].isNotEmpty) {
      initials += words[0][0].toUpperCase();
      if (words.length > 1 && words[1].isNotEmpty) {
        initials += words[1][0].toUpperCase();
      }
    }
    if (initials.isEmpty) initials = 'V';

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width.isInfinite ? width : width.w,
        height: height.isInfinite ? height : height.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            decoration: BoxDecoration(
              // Subtle gradient from thumbColor (already very dark) to near-black
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color.alphaBlend(
                    video.thumbColor.withValues(alpha: 0.85),
                    const Color(0xFF111111),
                  ),
                  const Color(0xFF0A0A0A),
                ],
              ),
              border: Border.all(
                color: video.thumbColor.withValues(alpha: 0.30),
                width: 0.8.w,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Large monogram watermark — slightly visible for depth
                Positioned(
                  top: -10.h,
                  right: -8.w,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.08),
                      fontSize: 80.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                // 3. Centered play button with app primary gradient ring
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.45),
                          blurRadius: 14.r,
                          spreadRadius: 1.r,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 22.r,
                    ),
                  ),
                ),

                // 4. LIVE badge — top-left, red glow
                if (video.isLive)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(3.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFE53935,
                            ).withValues(alpha: 0.6),
                            blurRadius: 6.r,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5.r,
                            height: 5.r,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 5. Episode count — top-right, uses app accent gradient
                if (epCount > 0)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(3.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 4.r,
                          ),
                        ],
                      ),
                      child: Text(
                        '$epCount Tập',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                // 6. Bottom gradient + title (Netflix-style)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.surface, Colors.transparent],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(8.w, 20.h, 8.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Thin accent line above title — premium touch
                        Container(
                          width: 20.w,
                          height: 2.h,
                          margin: EdgeInsets.only(bottom: 4.h),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(1.r),
                          ),
                        ),
                        Text(
                          video.isLive ? video.title : video.author,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
