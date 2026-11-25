// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'weather_palette.dart';

/// Membangun ThemeData terpusat dari WeatherPalette aktif.
class AppTheme {
  static ThemeData build(WeatherPalette p) {
    final brightness = p.isLight ? Brightness.light : Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
        brightness: brightness,
      ).copyWith(
        primary: p.buttonFill,
        secondary: p.accent,
        error: p.error,
      ),
    );

    return base.copyWith(
      extensions: [p],
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: p.textPrimary,
        displayColor: p.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.textPrimary,
        centerTitle: false,
        systemOverlayStyle:
            p.isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      ),
      iconTheme: IconThemeData(color: p.textPrimary),
      dividerTheme: DividerThemeData(color: p.divider, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accent),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.accent,
        selectionColor: p.accent.withValues(alpha: 0.35),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.buttonFill,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
