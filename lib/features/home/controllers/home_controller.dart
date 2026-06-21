import 'package:get/get.dart';
import '../../../core/models/video.dart';
import '../../../core/services/iptv_service.dart';

/// A titled horizontal rail on the Home discovery page.
class HomeRail {
  final String title;
  final List<Video> videos;
  const HomeRail(this.title, this.videos);
}

/// Builds the Home discovery content from live iptv-org channels.
///
/// Each iptv-org category becomes one rail; the featured banner reuses the
/// first channels of the first rail.
class HomeController extends GetxController {
  final RxBool loading = true.obs;
  final RxString error = ''.obs;
  final RxList<HomeRail> rails = <HomeRail>[].obs;

  /// Channels shown in the featured banner (top of the first rail).
  List<Video> get featured =>
      rails.isEmpty ? const [] : rails.first.videos.take(5).toList();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    error.value = '';
    try {
      final groups = await IptvService.fetchGroups();
      rails.assignAll([
        for (final g in groups) HomeRail(g.title, g.channels),
      ]);
      if (rails.isEmpty) {
        error.value = 'No live channels available right now.';
      }
    } catch (e) {
      error.value = 'Failed to load live channels.';
    } finally {
      loading.value = false;
    }
  }
}
