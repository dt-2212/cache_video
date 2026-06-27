import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../controllers/profile_controller.dart';
import '../widgets/activity_overview.dart';
import '../widgets/language_bottom_sheet.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final data = Get.find<AppDataController>();
    final auth = AuthService.to;
    final l10n = AppLocalizations.of(context)!;
    final currentLangTag = Localizations.localeOf(context).languageCode == 'vi'
        ? 'Tiếng Việt'
        : 'English';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: 16.h),
            Obx(() => ProfileHeader(user: auth.user.value, l10n: l10n)),
            SizedBox(height: 24.h),
            Obx(() {
              data.liked.length;
              data.history.length;
              return ActivityOverview(
                favoriteCount: controller.favoriteCount,
                watchedCount: controller.watchedCount,
                l10n: l10n,
              );
            }),
            SizedBox(height: 20.h),
            _sectionHeader(l10n.preferences),
            _cardContainer([
              ProfileTile(
                icon: Icons.language_rounded,
                iconColor: AppColors.blue,
                title: l10n.language,
                value: currentLangTag,
                onTap: () => LanguageBottomSheet.show(context, controller, l10n),
              ),
            ]),
            SizedBox(height: 16.h),
            _sectionHeader(l10n.support),
            _cardContainer([
              const ProfileTile(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.purple,
                title: 'About',
                value: 'v1.0.0',
              ),
            ]),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () => auth.isLoggedIn
                    ? _actionButton(
                        icon: Icons.logout_rounded,
                        label: l10n.signOut,
                        color: AppColors.destructive,
                        onTap: () async {
                          await auth.signOut();
                          Get.offAllNamed<void>(Routes.login);
                        },
                      )
                    : _actionButton(
                        icon: Icons.login_rounded,
                        label: l10n.signIn,
                        color: AppColors.primary,
                        onTap: () => Get.toNamed<void>(Routes.login),
                      ),
              ),
            ),
            SizedBox(height: 76.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _cardContainer(List<Widget> children) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
