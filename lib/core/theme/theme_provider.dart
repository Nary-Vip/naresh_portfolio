import 'dart:async';

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static const Duration transitionDuration = Duration(milliseconds: 600);

  ThemeMode _themeMode = ThemeMode.dark; // Default to dark pitch theme
  Timer? _transitionLock;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    // Ignore taps mid-transition so the animation isn't restarted halfway.
    if (_transitionLock?.isActive ?? false) return;
    _transitionLock = Timer(transitionDuration, () {});

    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  @override
  void dispose() {
    _transitionLock?.cancel();
    super.dispose();
  }
}
