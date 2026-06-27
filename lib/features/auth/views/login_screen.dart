import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

/// Entry screen: sign in with Google, or continue as a guest.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signIn() async {
    final ok = await AuthService.to.signInWithGoogle();
    if (ok) Get.offAllNamed<void>(Routes.main);
  }

  void _guest() {
    AuthService.to.continueAsGuest();
    Get.offAllNamed<void>(Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              const Icon(Icons.play_circle_fill,
                  size: 88, color: Color(0xFFED8F03)),
              const SizedBox(height: 20),
              const Text(
                'DramaShort',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Xem phim ngắn HLS, mọi lúc mọi nơi',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const Spacer(flex: 4),
              Obx(
                () => _GoogleButton(
                  busy: auth.isBusy.value,
                  onPressed: auth.isBusy.value ? null : _signIn,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _guest,
                child: const Text(
                  'Vào với tư cách khách',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Khách vẫn xem được phim; đăng nhập để đồng bộ yêu thích & lịch sử.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final bool busy;
  final VoidCallback? onPressed;
  const _GoogleButton({required this.busy, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: busy
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.g_mobiledata, size: 28, color: Color(0xFF4285F4)),
                SizedBox(width: 8),
                Text('Đăng nhập bằng Google',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
    );
  }
}
