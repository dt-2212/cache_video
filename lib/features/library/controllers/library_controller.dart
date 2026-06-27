import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';

class LibraryController extends GetxController {
  final AppDataController _data = Get.find();
  final RxInt selectedTab = 0.obs;

  List<Video> get favorites => _data.favorites;
  List<Video> get history => _data.watched;
}
