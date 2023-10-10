import 'package:shared_preferences/shared_preferences.dart';

/// Class for initializing shared preferences for caching user preferred theme.
class CacheMemory {
  static SharedPreferences? prefs;

  // Constant value for theme
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';

  static void initializePdfTheme() async {
    prefs ??= await SharedPreferences.getInstance();
  }
}
