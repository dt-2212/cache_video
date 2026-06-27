import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/google_button.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.4),
            radius: 1.2,
            colors: [
              AppColors.primary.withValues(alpha: 0.15),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 3),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 2.r,
                      ),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 64.r,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                Text(
                  l10n.appTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  l10n.appSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
                const Spacer(flex: 4),
                Obx(
                  () => GoogleButton(
                    busy: auth.isBusy.value,
                    label: l10n.signInWithGoogle,
                    onPressed: auth.isBusy.value ? null : _signIn,
                  ),
                ),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: _guest,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      l10n.continueAsGuest,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  l10n.guestNote,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white30, fontSize: 11.sp),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
