import 'package:shared_preferences/shared_preferences.dart';

/// Storage keys used for persistence in SharedPreferences.
abstract class StorageKeys {
  static const String language = 'app_language';
  static const String favorites = 'favorites';
  static const String history = 'history';
}

/// Centralized service to handle persistence of user preferences, favorites, and history.
class LocalStorageService {
  static late final SharedPreferences _prefs;

  /// Initialize SharedPreferences instance.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get saved language code.
  static String? getLanguage() => _prefs.getString(StorageKeys.language);

  /// Save selected language code.
  static Future<void> saveLanguage(String code) =>
      _prefs.setString(StorageKeys.language, code);

  /// Get saved favorites (liked video IDs).
  static List<String> getFavorites() =>
      _prefs.getStringList(StorageKeys.favorites) ?? [];

  /// Save favorites (liked video IDs).
  static Future<void> saveFavorites(List<String> ids) =>
      _prefs.setStringList(StorageKeys.favorites, ids);

  /// Get saved watch history video IDs.
  static List<String> getHistory() =>
      _prefs.getStringList(StorageKeys.history) ?? [];

  /// Save watch history video IDs.
  static Future<void> saveHistory(List<String> ids) =>
      _prefs.setStringList(StorageKeys.history, ids);
}
