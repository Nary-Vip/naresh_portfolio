import 'package:flutter/material.dart';

class AppTheme {
  /// Primary typeface, bundled under assets/fonts (no runtime download).
  static const String fontFamily = 'PlusJakartaSans';

  /// Bundled color-emoji font, used as a global fallback so emoji render
  /// anywhere text does — CanvasKit has no system fonts to fall back to.
  static const List<String> fontFallback = <String>['NotoColorEmoji'];

  static TextStyle _text(
    Color color,
    double size,
    FontWeight weight, {
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      color: color,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextTheme _textTheme(Color text, Color muted) {
    return TextTheme(
      displayLarge: _text(text, 64, FontWeight.bold, letterSpacing: -1.5),
      displayMedium: _text(text, 48, FontWeight.bold, letterSpacing: -0.5),
      titleLarge: _text(text, 24, FontWeight.w600),
      titleMedium: _text(text, 18, FontWeight.w600),
      bodyLarge: _text(text, 16, FontWeight.normal, height: 1.6),
      bodyMedium: _text(muted, 14, FontWeight.normal, height: 1.5),
    );
  }
  // Light Theme Colors
  static const Color lightBg = Color(0xFFF9FAFB);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(
    0xFFF25C05,
  ); // High contrast warm orange
  static const Color lightSecondary = Color(0xFF1E293B); // Slate-800
  static const Color lightText = Color(0xFF0F172A); // Slate-900
  static const Color lightTextMuted = Color(0xFF64748B); // Slate-500

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF000000); // Pitch black
  static const Color darkSurface = Color(
    0xFF111111,
  ); // Elevated deep charcoal card background
  static const Color darkPrimary = Color(0xFFFF6B00); // Neon orange
  static const Color darkSecondary = Color(0xFFE2E8F0); // Slate-200
  static const Color darkText = Color(0xFFF8FAFC); // Slate-50
  static const Color darkTextMuted = Color(0xFF94A3B8); // Slate-400

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      primaryColor: lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
        error: Colors.redAccent,
      ),
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      textTheme: _textTheme(lightText, lightTextMuted),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
        error: Colors.redAccent,
      ),
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      textTheme: _textTheme(darkText, darkTextMuted),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
    );
  }
}
