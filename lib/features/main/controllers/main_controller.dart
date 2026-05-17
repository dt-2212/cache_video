import 'package:get/get.dart';

/// Owns the selected bottom-navigation tab index.
class MainController extends GetxController {
  final RxInt currentTab = 0.obs;

  /// Index of the Reels tab (the only full-screen video tab).
  static const int reelTab = 1;

  bool get isReelActive => currentTab.value == reelTab;

  void changeTab(int index) => currentTab.value = index;
}
