import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_pages.dart';
import 'core/services/auth_service.dart';
import 'core/services/precache_manager.dart';
import 'l10n/app_localizations.dart';

import 'core/data/local/local_storage_service.dart';

import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize local storage
  await LocalStorageService.init();
  // Resolve simulator vs. device so the HLS disk cache is only used where it
  // works (real devices).
  await PreCacheManager.init();
  // Register auth (Google sign-in + guest mode) globally before the UI starts.
  await Get.putAsync<AuthService>(() => AuthService().init(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final savedLang = LocalStorageService.getLanguage();
    final initialLocale = savedLang != null ? Locale(savedLang) : null;

    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          locale: initialLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.background,
            useMaterial3: true,
            fontFamily: GoogleFonts.inter().fontFamily,
            textTheme: _applyLetterSpacing(
              GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
            ),
          ),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
        );
      },
    );
  }

  TextTheme _applyLetterSpacing(TextTheme baseTheme) {
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(letterSpacing: 0),
      displayMedium: baseTheme.displayMedium?.copyWith(letterSpacing: 0),
      displaySmall: baseTheme.displaySmall?.copyWith(letterSpacing: 0),
      headlineLarge: baseTheme.headlineLarge?.copyWith(letterSpacing: 0),
      headlineMedium: baseTheme.headlineMedium?.copyWith(letterSpacing: 0),
      headlineSmall: baseTheme.headlineSmall?.copyWith(letterSpacing: 0),
      titleLarge: baseTheme.titleLarge?.copyWith(letterSpacing: 0),
      titleMedium: baseTheme.titleMedium?.copyWith(letterSpacing: 0),
      titleSmall: baseTheme.titleSmall?.copyWith(letterSpacing: 0),
      bodyLarge: baseTheme.bodyLarge?.copyWith(letterSpacing: 0),
      bodyMedium: baseTheme.bodyMedium?.copyWith(letterSpacing: 0),
      bodySmall: baseTheme.bodySmall?.copyWith(letterSpacing: 0),
      labelLarge: baseTheme.labelLarge?.copyWith(letterSpacing: 0),
      labelMedium: baseTheme.labelMedium?.copyWith(letterSpacing: 0),
      labelSmall: baseTheme.labelSmall?.copyWith(letterSpacing: 0),
    );
  }
}
