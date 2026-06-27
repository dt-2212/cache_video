import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/library_controller.dart';
import '../widgets/video_grid_tab.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final controller = Get.find<LibraryController>();
  final data = Get.find<AppDataController>();
  Worker? _tabWorker;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: controller.selectedTab.value,
    );

    _tabWorker = ever(controller.selectedTab, (int index) {
      if (_tabController.index != index) {
        _tabController.animateTo(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.selectedTab.value = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabWorker?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                tabs: [
                  Tab(text: l10n.favorites),
                  Tab(text: l10n.watched),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Obx(() => VideoGridTab(
                        videos: controller.favorites,
                        emptyText: 'No favorites yet.\nTap ❤ on a video to save it.',
                      )),
                  Obx(() => VideoGridTab(
                        videos: controller.history,
                        emptyText: 'Nothing watched yet.',
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
