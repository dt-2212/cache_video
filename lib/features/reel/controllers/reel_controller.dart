import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';

/// Provides the video list for the Reels feed.
class ReelController extends GetxController {
  final AppDataController _data = Get.find();

  List<Video> get videos => _data.videos;
}
