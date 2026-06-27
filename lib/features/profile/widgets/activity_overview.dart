import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class ActivityOverview extends StatelessWidget {
  final int favoriteCount;
  final int watchedCount;
  final AppLocalizations l10n;
  final VoidCallback? onTapFavorites;
  final VoidCallback? onTapWatched;

  const ActivityOverview({
    super.key,
    required this.favoriteCount,
    required this.watchedCount,
    required this.l10n,
    this.onTapFavorites,
    this.onTapWatched,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.favorite_rounded,
              iconColor: AppColors.destructive,
              count: '$favoriteCount',
              label: l10n.favorites,
              onTap: onTapFavorites,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _statCard(
              icon: Icons.history_rounded,
              iconColor: AppColors.success,
              count: '$watchedCount',
              label: l10n.watched,
              onTap: onTapWatched,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 22.r),
            ),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
