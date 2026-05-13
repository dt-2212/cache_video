import 'package:get/get.dart';
import '../bindings/initial_binding.dart';
import '../widgets/feed_viewer_screen.dart';
import '../../features/main/views/main_navigation.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/views/splash_screen.dart';
import 'app_routes.dart';

/// GetX page table. The main route owns [InitialBinding] which registers the
/// shared + feature controllers used by the four tabs.
abstract class AppPages {
  AppPages._(); 

  static const String initial = Routes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainNavigation(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.feed,
      page: () => const FeedViewerScreen(),
      transition: Transition.downToUp,
    ),
  ];
}
