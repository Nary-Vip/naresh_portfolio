import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark pitch theme
  Offset? _togglePosition;
  bool _isTransitioning = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  Offset? get togglePosition => _togglePosition;
  bool get isTransitioning => _isTransitioning;

  void toggleTheme({Offset? position}) {
    if (_isTransitioning) return; // Lock during transition

    _togglePosition = position;
    _isTransitioning = true;
    notifyListeners();

    // Toggle the actual theme mode
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    
    // We let the UI animation know that the theme state has updated.
    notifyListeners();
  }

  void endTransition() {
    _isTransitioning = false;
    _togglePosition = null;
    notifyListeners();
  }
}
