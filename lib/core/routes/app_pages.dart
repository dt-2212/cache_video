import 'package:get/get.dart';
import '../bindings/initial_binding.dart';
import '../../features/feed/views/feed_viewer_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/main/views/main_navigation.dart';
import '../../features/reel/views/episode_list_screen.dart';
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
      name: Routes.login,
      page: () => const LoginScreen(),
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
    GetPage(
      name: Routes.episodes,
      page: () => const EpisodeListScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
