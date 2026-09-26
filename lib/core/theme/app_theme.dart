import 'package:flutter/material.dart';

/// Semantic colours for the portfolio. Widgets read these via `context.palette`
/// instead of hardcoding `Colors.black54` / `Colors.white70` per theme.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Headings, card titles, names.
  final Color textPrimary;

  /// Body copy: paragraphs, bullets, descriptions.
  final Color textSecondary;

  /// Metadata: dates, locations, captions, field labels.
  final Color textMuted;

  /// Opaque card background.
  final Color surface;

  /// Chips, inputs, image placeholders — a step off the card surface.
  final Color surfaceMuted;

  /// Card borders and dividers.
  final Color border;

  const AppPalette({
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
  });

  // Light: slate scale on white. Muted #64748B is 4.8:1 on white (WCAG AA).
  static const AppPalette light = AppPalette(
    textPrimary: Color(0xFF0F172A), // slate-900
    textSecondary: Color(0xFF334155), // slate-700
    textMuted: Color(0xFF64748B), // slate-500
    surface: Colors.white,
    surfaceMuted: Color(0xFFF1F5F9), // slate-100
    border: Color(0xFFE2E8F0), // slate-200
  );

  static const AppPalette dark = AppPalette(
    textPrimary: Color(0xFFF8FAFC), // slate-50
    textSecondary: Color(0xFFCBD5E1), // slate-300
    textMuted: Color(0xFF94A3B8), // slate-400
    surface: Color(0xFF111111),
    surfaceMuted: Color(0xFF1A1A1A),
    border: Color(0xFF262626),
  );

  @override
  AppPalette copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? surface,
    Color? surfaceMuted,
    Color? border,
  }) {
    return AppPalette(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
    );
  }

  // Lerped so the palette animates with the theme toggle like everything else.
  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

class AppTheme {
  /// Primary typeface, bundled under assets/fonts (no runtime download).
  static const String fontFamily = 'PlusJakartaSans';

  static TextStyle _text(
    Color color,
    double size,
    FontWeight weight, {
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      color: color,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // One type scale for the whole site. Sections pick a role, not a pixel size:
  //   headlineSmall  28  section headings / CTA headline
  //   titleLarge     22  primary card titles (role, project, school)
  //   titleMedium    18  secondary card titles (research topic, contact form)
  //   titleSmall     16  compact card titles (metric labels, certifications)
  //   bodyLarge      16  paragraphs
  //   bodyMedium     14  card body, bullets, descriptions
  //   bodySmall      13  metadata: dates, locations, captions
  static TextTheme _textTheme(AppPalette p) {
    return TextTheme(
      displayLarge: _text(p.textPrimary, 64, FontWeight.bold, letterSpacing: -1.5),
      displayMedium: _text(p.textPrimary, 48, FontWeight.bold, letterSpacing: -0.5),
      headlineSmall: _text(p.textPrimary, 28, FontWeight.w700, height: 1.25),
      titleLarge: _text(p.textPrimary, 22, FontWeight.w700, height: 1.3),
      titleMedium: _text(p.textPrimary, 18, FontWeight.w700, height: 1.35),
      titleSmall: _text(p.textPrimary, 16, FontWeight.w700, height: 1.35),
      bodyLarge: _text(p.textSecondary, 16, FontWeight.w400, height: 1.6),
      bodyMedium: _text(p.textSecondary, 14, FontWeight.w400, height: 1.55),
      bodySmall: _text(p.textMuted, 13, FontWeight.w400, height: 1.5),
    );
  }

  // Light Theme Colors
  static const Color lightBg = Color(0xFFF9FAFB);
  static const Color lightPrimary = Color(0xFFF25C05); // High contrast warm orange
  static const Color lightSecondary = Color(0xFF1E293B); // Slate-800

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF000000); // Pitch black
  static const Color darkPrimary = Color(0xFFFF6B00); // Neon orange
  static const Color darkSecondary = Color(0xFFE2E8F0); // Slate-200

  // Built once; getters allocated a fresh ThemeData on every MaterialApp rebuild.
  static final ThemeData lightTheme = _build(
    brightness: Brightness.light,
    background: lightBg,
    primary: lightPrimary,
    secondary: lightSecondary,
    palette: AppPalette.light,
  );
  static final ThemeData darkTheme = _build(
    brightness: Brightness.dark,
    background: darkBg,
    primary: darkPrimary,
    secondary: darkSecondary,
    palette: AppPalette.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color primary,
    required Color secondary,
    required AppPalette palette,
  }) {
    final base = brightness == Brightness.light
        ? const ColorScheme.light()
        : const ColorScheme.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: base.copyWith(
        primary: primary,
        secondary: secondary,
        surface: palette.surface,
        onSurface: palette.textPrimary,
        onSurfaceVariant: palette.textSecondary,
        // Material 3 derives Divider colours from these; the defaults were near-black.
        outline: palette.border,
        outlineVariant: palette.border,
        error: Colors.redAccent,
      ),
      fontFamily: fontFamily,
      textTheme: _textTheme(palette),
      extensions: [palette],
      dividerTheme: DividerThemeData(color: palette.border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.border, width: 1.5),
        ),
      ),
    );
  }
}
