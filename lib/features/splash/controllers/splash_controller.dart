import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

/// Holds the splash screen briefly, then routes to the main shell.
class SplashController extends GetxController {
  static const Duration _holdDuration = Duration(seconds: 2);

  @override
  void onReady() {
    super.onReady();
    _goToMain();
  }

  Future<void> _goToMain() async {
    await Future<void>.delayed(_holdDuration);
    // offAllNamed so the splash is removed from the navigation stack.
    await Get.offAllNamed<void>(Routes.main);
  }
}
