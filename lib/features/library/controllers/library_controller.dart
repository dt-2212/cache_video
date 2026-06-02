import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';

/// Exposes the user's favorites and watch history for the My List screen.
class LibraryController extends GetxController {
  final AppDataController _data = Get.find();

  List<Video> get favorites => _data.favorites;
  List<Video> get history => _data.watched;
}
