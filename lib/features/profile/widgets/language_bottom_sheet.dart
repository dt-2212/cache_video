import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../controllers/profile_controller.dart';

/// Modal bottom sheet for selecting the application language.
class LanguageBottomSheet extends StatelessWidget {
  final ProfileController controller;
  final AppLocalizations l10n;

  const LanguageBottomSheet({
    super.key,
    required this.controller,
    required this.l10n,
  });

  static void show(
    BuildContext context,
    ProfileController controller,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => LanguageBottomSheet(controller: controller, l10n: l10n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = Localizations.localeOf(context).languageCode;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              l10n.selectLanguage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: Text(
                l10n.english,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: currentLang == 'en'
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                controller.changeLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇻🇳', style: TextStyle(fontSize: 24)),
              title: Text(
                l10n.vietnamese,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: currentLang == 'vi'
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                controller.changeLanguage('vi');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
