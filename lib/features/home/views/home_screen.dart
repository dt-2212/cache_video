import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import '../widgets/error_state.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/video_rail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (controller.error.isNotEmpty) {
          return HomeErrorState(
            message: controller.error.value,
            onRetry: controller.load,
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.load(showLoader: false),
          color: Colors.white,
          backgroundColor: Colors.black87,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                floating: true,
                elevation: 0,
                title: Text(
                  'FlexStream',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
              SliverToBoxAdapter(
                child: FeaturedCarousel(videos: controller.featured),
              ),
              for (final rail in controller.rails)
                SliverToBoxAdapter(
                  child: VideoRail(title: rail.title, videos: rail.videos),
                ),
              SliverToBoxAdapter(child: SizedBox(height: 70.h)),
            ],
          ),
        );
      }),
    );
  }
}
