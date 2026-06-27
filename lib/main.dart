import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/services/auth_service.dart';
import 'core/services/precache_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Short Video App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
