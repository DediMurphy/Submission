import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _preferences.getBool(_themeKey) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _preferences.setBool(_themeKey, value);
  }
}
