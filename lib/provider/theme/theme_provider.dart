import 'package:flutter/material.dart';
import 'package:restaurantapp/data/service/shared_preferences_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferencesService _preferencesService;
  ThemeMode _themeMode;

  ThemeProvider(this._preferencesService)
      : _themeMode =
            _preferencesService.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _preferencesService.setDarkMode(isDark);
    notifyListeners();
  }
}
