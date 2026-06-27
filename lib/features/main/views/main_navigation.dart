import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_screen.dart';
import '../../reel/views/reel_screen.dart';
import '../../library/views/library_screen.dart';
import '../../profile/views/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late PageController _pageController;
  final controller = Get.find<MainController>();
  Worker? _tabWorker;

  static const _pages = [
    HomeScreen(),
    ReelScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: controller.currentTab.value);

    _tabWorker = ever(controller.currentTab, (int index) {
      if (_pageController.hasClients &&
          _pageController.page?.round() != index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabWorker?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final selected = controller.currentTab.value;
      final bottomInset = MediaQuery.of(context).padding.bottom;
      final finalBottomPadding =
          8.h + (bottomInset > 0 ? bottomInset * 0.35 : 0.0);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _pages,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.92),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.06),
                      width: 0.6.h,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 8.h,
                    bottom: finalBottomPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(
                        icon: Icons.home_filled,
                        label: l10n.home,
                        active: selected == 0,
                        onTap: () => controller.changeTab(0),
                      ),
                      _navItem(
                        icon: Icons.play_circle_fill_rounded,
                        label: l10n.reels,
                        active: selected == 1,
                        onTap: () => controller.changeTab(1),
                      ),
                      _navItem(
                        icon: Icons.video_library_rounded,
                        label: l10n.myList,
                        active: selected == 2,
                        onTap: () => controller.changeTab(2),
                      ),
                      _navItem(
                        icon: Icons.person_rounded,
                        label: l10n.profile,
                        active: selected == 3,
                        onTap: () => controller.changeTab(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.textMuted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: active ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: active ? activeColor : inactiveColor,
                size: 22.r,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: active ? activeColor : inactiveColor,
                fontSize: 10.sp,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
