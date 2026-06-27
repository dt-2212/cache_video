import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../feed/views/feed_viewer_screen.dart';
import '../../../core/widgets/video_feed.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/reel_controller.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<ReelController>();
    final main = Get.find<MainController>();
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Obx(
          () => VideoFeed(
            // Show only EP1 of each series — swiping changes series, not episodes
            videos: controller.seriesFirstEpisodes,
            isActive: main.isReelActive,
            onEpisodesTap: openSeriesFeed,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h, left: 16.w),
            child: Text(
              l10n.reels,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
