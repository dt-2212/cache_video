import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';

import '../../../core/data/local/local_storage_service.dart';

/// Exposes profile stats derived from the shared app data.
class ProfileController extends GetxController {
  final AppDataController _data = Get.find();

  int get favoriteCount => _data.liked.length;
  int get watchedCount => _data.history.length;

  void changeLanguage(String languageCode) {
    Get.updateLocale(Locale(languageCode));
    LocalStorageService.saveLanguage(languageCode);
  }
}
