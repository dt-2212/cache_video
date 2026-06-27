import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';
import '../../../core/services/channel_service.dart';

class HomeRail {
  final String title;
  final List<Video> videos;
  const HomeRail(this.title, this.videos);
}

class HomeController extends GetxController {
  final RxBool loading = true.obs;
  final RxString error = ''.obs;
  final RxList<HomeRail> rails = <HomeRail>[].obs;
  final RxList<Video> _liveChannels = <Video>[].obs;

  List<Video> get featured =>
      rails.isEmpty ? const [] : rails.first.videos.take(5).toList();

  @override
  void onInit() {
    super.onInit();
    load();
    ever(Get.find<AppDataController>().videos, (_) => _combineRails());
    ever(_liveChannels, (_) => _combineRails());
  }

  Future<void> load({bool showLoader = true}) async {
    if (showLoader) loading.value = true;
    error.value = '';
    try {
      final groups = await ChannelService.fetchGroups();
      if (groups.isNotEmpty) {
        _liveChannels.assignAll(groups.first.channels);
      }
      _combineRails();
      if (rails.isEmpty) {
        error.value = 'No channels or series available.';
      }
    } catch (e) {
      error.value = 'Failed to load live channels.';
      debugPrint('Error loading live channels: $e');
    } finally {
      if (showLoader) loading.value = false;
    }

    if (ChannelService.validateStreams && _liveChannels.isNotEmpty) {
      unawaited(_pruneDeadChannels());
    }
  }

  void _combineRails() {
    final dataController = Get.find<AppDataController>();
    final List<HomeRail> combined = [];

    final categoryGroups = <String, List<Video>>{};
    for (final v in dataController.uniqueSeries) {
      (categoryGroups[v.category] ??= []).add(v);
    }
    categoryGroups.forEach((category, list) {
      combined.add(HomeRail(category, list));
    });

    if (_liveChannels.isNotEmpty) {
      combined.insert(0, HomeRail('Live TV', _liveChannels.toList()));
    }

    rails.assignAll(combined);
  }

  Future<void> _pruneDeadChannels() async {
    final ok = await ChannelService.playableUrls(_liveChannels);
    final pruned = _liveChannels.where((v) => ok.contains(v.url)).toList();
    _liveChannels.assignAll(pruned);
  }
}
