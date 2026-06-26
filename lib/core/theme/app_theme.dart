import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightBg = Color(0xFFF9FAFB);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFFF25C05); // High contrast warm orange
  static const Color lightSecondary = Color(0xFF1E293B); // Slate-800
  static const Color lightText = Color(0xFF0F172A); // Slate-900
  static const Color lightTextMuted = Color(0xFF64748B); // Slate-500

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF000000); // Pitch black
  static const Color darkSurface = Color(0xFF111111); // Elevated deep charcoal card background
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
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: lightText,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.outfit(
          color: lightText,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.outfit(
          color: lightText,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.outfit(
          color: lightText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: lightText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          color: lightTextMuted,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
      ),
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
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: darkText,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.outfit(
          color: darkText,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.outfit(
          color: darkText,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.outfit(
          color: darkText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: darkText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          color: darkTextMuted,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
      ),
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
