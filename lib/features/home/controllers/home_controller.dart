import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/models/video.dart';
import '../../../core/services/channel_service.dart';

/// A titled horizontal rail on the Home discovery page.
class HomeRail {
  final String title;
  final List<Video> videos;
  const HomeRail(this.title, this.videos);
}

/// Builds the Home discovery content from live channels.
///
/// Each channel group becomes one rail; the featured banner reuses the first
/// channels of the first rail.
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

  /// Loads the channel rails. Pass [showLoader] = false for a pull-to-refresh,
  /// so the existing list stays visible and only the refresh spinner shows
  /// instead of the full-screen loader.
  Future<void> load({bool showLoader = true}) async {
    debugPrint('🏠 HomeController.load START showLoader=$showLoader');
    if (showLoader) loading.value = true;
    error.value = '';
    try {
      final groups = await ChannelService.fetchGroups();
      rails.assignAll([for (final g in groups) HomeRail(g.title, g.channels)]);
      if (rails.isEmpty) {
        error.value = 'No live channels available right now.';
      }
      debugPrint(
        '🏠 HomeController.load OK rails=${rails.length} '
        'featured=${featured.length} error="${error.value}"',
      );
    } catch (e) {
      error.value = 'Failed to load live channels.';
      debugPrint('🏠 HomeController.load ERROR $e');
    } finally {
      if (showLoader) loading.value = false;
    }
    // Show channels immediately, then drop the dead ones in the background.
    if (ChannelService.validateStreams && rails.isNotEmpty) {
      unawaited(_pruneDeadChannels());
    }
  }

  /// Probe every shown channel and remove the ones that don't play. Rails that
  /// end up empty are dropped. Runs after the first paint so it never blocks.
  Future<void> _pruneDeadChannels() async {
    final all = [for (final r in rails) ...r.videos];
    final ok = await ChannelService.playableUrls(all);
    final pruned = [
      for (final r in rails)
        HomeRail(r.title, [
          for (final v in r.videos)
            if (ok.contains(v.url)) v,
        ]),
    ].where((r) => r.videos.isNotEmpty).toList();
    rails.assignAll(pruned);
    debugPrint(
      '🏠 pruned: kept ${ok.length}/${all.length} channels, '
      'rails=${rails.length}',
    );
  }
}
