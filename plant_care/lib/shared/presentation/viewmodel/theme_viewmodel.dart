import 'package:flutter/material.dart';
import 'package:plant_care/shared/presentation/theme/theme.dart';

class ThemeViewModel extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme(bool enabled) {
    _isDarkMode = enabled;
    notifyListeners();
  }
}
