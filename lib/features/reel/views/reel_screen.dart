import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/video_feed.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/reel_controller.dart';

/// Reels = the main TikTok-style endless vertical feed.
class ReelScreen extends StatelessWidget {
  const ReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelController>();
    final main = Get.find<MainController>();

    return Stack(
      children: [
        Obx(
          () => VideoFeed(
            videos: controller.videos,
            isActive: main.isReelActive,
          ),
        ),
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 16),
            child: Text(
              'Reels',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
