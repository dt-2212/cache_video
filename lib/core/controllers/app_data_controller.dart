import 'package:get/get.dart';
import '../data/sample_videos.dart';
import '../models/video.dart';

import '../data/local/local_storage_service.dart';

/// Shared, app-wide state: the video catalogue plus the user's liked videos
/// and watch history. Registered permanently so every feature can `Get.find`.
class AppDataController extends GetxController {
  final RxList<Video> videos = <Video>[].obs;

  /// Liked video ids (My List · Favorites).
  final RxSet<String> liked = <String>{}.obs;

  /// Recently watched video ids, most-recent first (My List · History).
  final RxList<String> history = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    videos.assignAll(kSampleVideos);
    liked.addAll(LocalStorageService.getFavorites());
    history.assignAll(LocalStorageService.getHistory());
  }

  bool isLiked(String id) => liked.contains(id);

  void toggleLike(String id) {
    if (!liked.add(id)) {
      liked.remove(id);
    }
    LocalStorageService.saveFavorites(liked.toList());
  }

  void markWatched(String id) {
    history.remove(id);
    history.insert(0, id);
    LocalStorageService.saveHistory(history);
  }

  Video? byId(String id) {
    for (final v in videos) {
      if (v.id == id) return v;
    }
    return null;
  }

  List<Video> get favorites =>
      videos.where((v) => liked.contains(v.id)).toList();

  List<Video> get watched => [
        for (final id in history)
          if (byId(id) != null) byId(id)!,
      ];
}
