import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';

/// A titled horizontal rail on the Home discovery page.
class HomeRail {
  final String title;
  final List<Video> videos;
  const HomeRail(this.title, this.videos);
}

/// Builds the Home discovery content (featured banner + themed rails).
class HomeController extends GetxController {
  final AppDataController _data = Get.find();

  List<Video> get featured => _data.videos;

  List<HomeRail> get rails {
    final all = _data.videos;
    return [
      HomeRail('Trending Now', all),
      HomeRail('New Releases', all.reversed.toList()),
      HomeRail('Recommended For You', [...all.skip(1), ...all.take(1)]),
    ];
  }
}
