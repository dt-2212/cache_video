import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../models/video.dart';
import '../data/local/local_storage_service.dart';

class AppDataController extends GetxController {
  final RxList<Video> videos = <Video>[].obs;
  final RxSet<String> liked = <String>{}.obs;
  final RxList<String> history = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    liked.addAll(LocalStorageService.getFavorites());
    history.assignAll(LocalStorageService.getHistory());
    loadCatalog();
  }

  String _getCategoryForSlug(String slug) {
    slug = slug.toLowerCase();
    if (slug == 'hanh-dong' ||
        slug.contains('batman') ||
        slug.contains('avengers') ||
        slug.contains('dune') ||
        slug.contains('star-wars') ||
        slug.contains('steel')) {
      return 'Hành Động & Viễn Tưởng';
    } else if (slug == 'am-nhac' ||
        slug.contains('chaplin') ||
        slug.contains('keaton')) {
      return 'Hài Hước & Nghệ Thuật';
    } else if (slug == 'dai-duong' ||
        slug == 'phong-canh' ||
        slug == 'thanh-pho' ||
        slug == 'thien-nhien' ||
        slug.contains('bunny')) {
      return 'Thiên Nhiên & Phong Cảnh';
    } else {
      return 'Phim Thịnh Hành';
    }
  }

  Future<void> loadCatalog() async {
    try {
      final jsonStr = await rootBundle.loadString(AppConstants.catalogAssetPath);
      final replacedJsonStr = jsonStr.replaceAll(
        AppConstants.placeholderBaseUrl,
        AppConstants.videoBaseUrl,
      );
      final data = json.decode(replacedJsonStr) as Map<String, dynamic>;
      final seriesList = data['series'] as List<dynamic>;
      final List<Video> loadedVideos = [];

      final colors = [
        const Color(0xFF0E2A4A), // royal navy
        const Color(0xFF4A1020), // deep crimson
        const Color(0xFF0E3820), // forest green
        const Color(0xFF2A1050), // deep indigo
        const Color(0xFF0C2C2E), // deep jade teal
        const Color(0xFF3C1C08), // warm amber-brown
        const Color(0xFF3A0C22), // deep rose
        const Color(0xFF0E2240), // slate steel blue
      ];

      int colorIdx = 0;
      for (final s in seriesList) {
        final seriesTitle = s['title'] as String;
        final slug = s['slug'] as String;
        final episodes = s['episodes'] as List<dynamic>;
        final color = colors[colorIdx % colors.length];
        final category = _getCategoryForSlug(slug);
        colorIdx++;

        for (final ep in episodes) {
          final epTitle = ep['title'] as String;
          final url = ep['url'] as String;

          loadedVideos.add(Video(
            id: url,
            url: url,
            title: '$seriesTitle - $epTitle',
            category: category,
            author: seriesTitle,
            caption: '$seriesTitle - $epTitle',
            music: 'Original Soundtrack',
            thumbColor: color,
            isLive: false,
          ));
        }
      }
      videos.assignAll(loadedVideos);
    } catch (e) {
      debugPrint('Error loading catalog.json: $e');
    }
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

  List<Video> get uniqueSeries {
    final seen = <String>{};
    final List<Video> result = [];
    for (final v in videos) {
      if (!v.isLive) {
        if (seen.add(v.author)) {
          result.add(v);
        }
      }
    }
    return result;
  }

  List<Video> getEpisodesForSeries(String seriesTitle) {
    return videos.where((v) => v.author == seriesTitle).toList();
  }
}
