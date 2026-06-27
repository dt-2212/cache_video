import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';

/// Provides the video list for the Reels feed.
class ReelController extends GetxController {
  final AppDataController _data = Get.find();

  /// All videos (live + VOD).
  List<Video> get videos => _data.videos;

  /// Only the first episode of every series — used by the Reels home feed so
  /// swiping shows one item per series (not all episodes back-to-back).
  List<Video> get seriesFirstEpisodes => _data.uniqueSeries
      .where((v) => !v.isLive)
      .toList();
}
