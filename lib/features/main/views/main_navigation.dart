import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_screen.dart';
import '../../reel/views/reel_screen.dart';
import '../../library/views/library_screen.dart';
import '../../profile/views/profile_screen.dart';

/// Root scaffold with the 4 tabs: Home · Reel · Library · Profile.
///
/// Uses an [IndexedStack] to keep each tab alive; the Reel feed reads the
/// active tab so playback pauses automatically when its tab is not selected.
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  static const _pages = [
    HomeScreen(),
    ReelScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Obx(() {
      final selected = controller.currentTab.value;
      final isReelTab = selected == MainController.reelTab;
      return Scaffold(
        backgroundColor: Colors.black,
        extendBody: isReelTab,
        body: IndexedStack(index: selected, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selected,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isReelTab ? Colors.transparent : Colors.black,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_collection), label: 'Reel'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    });
  }
}
