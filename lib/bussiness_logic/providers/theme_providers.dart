import 'package:flutter/material.dart';
import '../../resources/utilities/constants.dart';
import '../../services/theme_cache.dart';

/// Provider for changing theme data
class ThemeProvider with ChangeNotifier {
  /// Getting initial state from shared preference, if not or (i.e. null), default will be dark.
  String getTheme = CacheMemory.prefs?.getString(themeKeyForSharedPreference) ??
      CacheMemory.darkTheme;

  /// Method for changing theme, by getting state from shared preference.
  void changeTheme() async {
    if (getTheme == CacheMemory.lightTheme) {
      getTheme = CacheMemory.darkTheme;
      await CacheMemory.prefs
          ?.setString(themeKeyForSharedPreference, CacheMemory.darkTheme);
      notifyListeners();
    } else if (getTheme == CacheMemory.darkTheme) {
      getTheme = CacheMemory.lightTheme;
      await CacheMemory.prefs
          ?.setString(themeKeyForSharedPreference, CacheMemory.lightTheme);
      notifyListeners();
    }
  }

  /// Method for changing theme value to be set in shared preference,
  /// so that data will persist after closing app.
  void changeThemeInCache() async {
    String? getThemeFromCache =
        CacheMemory.prefs?.getString(themeKeyForSharedPreference);

    if (getThemeFromCache == CacheMemory.darkTheme) {
      await CacheMemory.prefs
          ?.setString(themeKeyForSharedPreference, CacheMemory.lightTheme);
    } else if (getThemeFromCache == CacheMemory.lightTheme) {
      await CacheMemory.prefs
          ?.setString(themeKeyForSharedPreference, CacheMemory.darkTheme);
    } else if (getThemeFromCache == null) {
      await CacheMemory.prefs
          ?.setString(themeKeyForSharedPreference, CacheMemory.darkTheme);
    }
  }
}
