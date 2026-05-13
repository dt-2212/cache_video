import 'package:get/get.dart';
import '../controllers/app_data_controller.dart';
import '../../features/main/controllers/main_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/reel/controllers/reel_controller.dart';
import '../../features/library/controllers/library_controller.dart';
import '../../features/profile/controllers/profile_controller.dart';

/// Registers shared + feature controllers at app start. Tabs live in an
/// IndexedStack (always alive), so eager registration keeps things simple.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppDataController(), permanent: true);
    Get.put(MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ReelController());
    Get.lazyPut(() => LibraryController());
    Get.lazyPut(() => ProfileController());
  }
}
