import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

/// Holds the splash screen briefly, then routes to login or the main shell
/// depending on whether the user has signed in / chosen guest mode before.
class SplashController extends GetxController {
  static const Duration _holdDuration = Duration(seconds: 2);

  @override
  void onReady() {
    super.onReady();
    _route();
  }

  Future<void> _route() async {
    await Future<void>.delayed(_holdDuration);
    final dest =
        AuthService.to.hasEntered ? Routes.main : Routes.login;
    debugPrint('🚀 Splash -> $dest');
    // offAllNamed so the splash is removed from the navigation stack.
    await Get.offAllNamed<void>(dest);
  }
}
