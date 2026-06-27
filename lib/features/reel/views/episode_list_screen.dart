import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/episode_list_sheet.dart';
import '../../feed/views/feed_viewer_screen.dart';

/// Full-screen episode list for a single series.
/// Navigated to via [openEpisodeList].
class EpisodeListScreen extends StatelessWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final video = Get.arguments as Video;
    final data = Get.find<AppDataController>();
    final episodes = data.getEpisodesForSeries(video.author);
    final color = video.thumbColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Get.back<void>(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.alphaBlend(
                        color.withValues(alpha: 0.9),
                        const Color(0xFF111111),
                      ),
                      AppColors.background,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 52.r,
                          height: 52.r,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: color.withValues(alpha: 0.4),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              seriesInitials(video.author),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          video.author,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${episodes.length} tập',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => EpisodeTile(
                  episode: episodes[i],
                  number: i + 1,
                  accentColor: color,
                  onTap: () => openFeed(episodes, i),
                ),
                childCount: episodes.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }
}

/// Pushes the full-screen episode list for [seriesVideo].
void openEpisodeList(Video seriesVideo) {
  Get.toNamed<void>(Routes.episodes, arguments: seriesVideo);
}
