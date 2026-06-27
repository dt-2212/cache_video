import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/app_user.dart';
import '../../../l10n/app_localizations.dart';

/// User header with avatar image (and fallback initial), display name, and email.
class ProfileHeader extends StatelessWidget {
  final AppUser? user;
  final AppLocalizations l10n;

  const ProfileHeader({super.key, required this.user, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoUrl;
    final displayName = user?.displayName ?? l10n.guest;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: user != null
                  ? [AppColors.blue, AppColors.teal]
                  : [Colors.white24, Colors.white10],
            ),
          ),
          child: ClipOval(
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.surfaceLight,
              child: photoUrl != null && photoUrl.isNotEmpty
                  ? Image.network(
                      photoUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          _fallbackAvatar(displayName, user != null),
                    )
                  : _fallbackAvatar(displayName, user != null),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          displayName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? l10n.watchingAsGuest,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _fallbackAvatar(String name, bool isLoggedIn) {
    final firstLetter = name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : 'G';
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLoggedIn
              ? [AppColors.slate, AppColors.lightBlue]
              : [AppColors.darkGradientStart, AppColors.darkGradientEnd],
        ),
      ),
      child: isLoggedIn
          ? Text(
              firstLetter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            )
          : const Icon(Icons.person_rounded, size: 44, color: Colors.white54),
    );
  }
}
