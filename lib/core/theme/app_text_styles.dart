// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_palette.dart';

/// Kumpulan gaya teks konsisten yang warnanya mengikuti WeatherPalette aktif.
class AppTextStyles {
  final WeatherPalette p;
  const AppTextStyles(this.p);

  /// Pemakaian: AppTextStyles.of(context).displayTemp
  static AppTextStyles of(BuildContext context) =>
      AppTextStyles(Theme.of(context).extension<WeatherPalette>()!);

  TextStyle get displayTemp => GoogleFonts.poppins(
        fontSize: 72,
        fontWeight: FontWeight.w300,
        color: p.textPrimary,
        height: 1.0,
      );

  TextStyle get headlineCity => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
        height: 1.25,
      );

  TextStyle get titleCondition => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: p.textPrimary,
        height: 1.3,
      );

  TextStyle get titleSection => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
        height: 1.3,
      );

  TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: p.textPrimary,
        height: 1.4,
      );

  TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: p.textSecondary,
        height: 1.4,
      );

  TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: p.textSecondary,
        height: 1.3,
      );

  TextStyle get valueDetail => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
        height: 1.2,
      );
}
