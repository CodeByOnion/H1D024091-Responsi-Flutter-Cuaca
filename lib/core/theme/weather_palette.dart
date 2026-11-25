// lib/core/theme/weather_palette.dart
import 'package:flutter/material.dart';
import 'weather_mood.dart';

LinearGradient _grad(int a, int b, int c) => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(a), Color(b), Color(c)],
      stops: const [0.0, 0.5, 1.0],
    );

/// Palet warna adaptif untuk tiap WeatherMood, dianimasikan oleh MaterialApp.
class WeatherPalette extends ThemeExtension<WeatherPalette> {
  final LinearGradient background;
  final Color blobA;
  final Color blobB;
  final Color glassFill;
  final Color glassFillSoft;
  final Color glassBorder;
  final Color glassShadow;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color buttonFill;
  final Color favorite;
  final Color error;
  final bool isLight;

  const WeatherPalette({
    required this.background,
    required this.blobA,
    required this.blobB,
    required this.glassFill,
    required this.glassFillSoft,
    required this.glassBorder,
    required this.glassShadow,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.buttonFill,
    required this.favorite,
    required this.error,
    required this.isLight,
  });

  // ---- Mood terang: teks gelap ----
  static final clear = WeatherPalette(
    background: _grad(0xFFE8FAF0, 0xFFC7F2DC, 0xFF9CE7C3),
    blobA: const Color(0x8CFFF1A8),
    blobB: const Color(0x99FFFFFF),
    glassFill: const Color(0xB8FFFFFF),
    glassFillSoft: const Color(0x73FFFFFF),
    glassBorder: const Color(0xD9FFFFFF),
    glassShadow: const Color(0x241B7F5C),
    divider: const Color(0x260B3D2E),
    textPrimary: const Color(0xFF0B3D2E),
    textSecondary: const Color(0xB80B3D2E),
    textMuted: const Color(0x800B3D2E),
    accent: const Color(0xFF1B7F5C),
    buttonFill: const Color(0xFF0E6B4B),
    favorite: const Color(0xFFE09F00),
    error: const Color(0xFFD32F2F),
    isLight: true,
  );

  static final partlyCloudy = WeatherPalette(
    background: _grad(0xFFCDEBDD, 0xFF9AD4BA, 0xFF6EC1A3),
    blobA: const Color(0x80FFFFFF),
    blobB: const Color(0x66D9F2E6),
    glassFill: const Color(0x99FFFFFF),
    glassFillSoft: const Color(0x59FFFFFF),
    glassBorder: const Color(0xBFFFFFFF),
    glassShadow: const Color(0x290B3D2E),
    divider: const Color(0x260B3D2E),
    textPrimary: const Color(0xFF0B3D2E),
    textSecondary: const Color(0xB80B3D2E),
    textMuted: const Color(0x800B3D2E),
    accent: const Color(0xFF1B7F5C),
    buttonFill: const Color(0xFF0E6B4B),
    favorite: const Color(0xFFE09F00),
    error: const Color(0xFFD32F2F),
    isLight: true,
  );

  // ---- Mood gelap: teks putih ----
  static final cloudy = WeatherPalette(
    background: _grad(0xFF5A7B71, 0xFF456A5E, 0xFF2F5246),
    blobA: const Color(0x1FFFFFFF),
    blobB: const Color(0x33A9C4BA),
    glassFill: const Color(0x29FFFFFF),
    glassFillSoft: const Color(0x1AFFFFFF),
    glassBorder: const Color(0x4DFFFFFF),
    glassShadow: const Color(0x4006251B),
    divider: const Color(0x1FFFFFFF),
    textPrimary: const Color(0xFFFFFFFF),
    textSecondary: const Color(0xBFFFFFFF),
    textMuted: const Color(0x8CFFFFFF),
    accent: const Color(0xFF7ED9B0),
    buttonFill: const Color(0xFF1B7F5C),
    favorite: const Color(0xFFFFD166),
    error: const Color(0xFFFF8A80),
    isLight: false,
  );

  static final rain = WeatherPalette(
    background: _grad(0xFF16302B, 0xFF0E231F, 0xFF081613),
    blobA: const Color(0x1F7ED9B0),
    blobB: const Color(0x334F7468),
    glassFill: const Color(0x1AFFFFFF),
    glassFillSoft: const Color(0x12FFFFFF),
    glassBorder: const Color(0x33FFFFFF),
    glassShadow: const Color(0x59020A08),
    divider: const Color(0x1FFFFFFF),
    textPrimary: const Color(0xFFFFFFFF),
    textSecondary: const Color(0xBFFFFFFF),
    textMuted: const Color(0x8CFFFFFF),
    accent: const Color(0xFF7ED9B0),
    buttonFill: const Color(0xFF1B7F5C),
    favorite: const Color(0xFFFFD166),
    error: const Color(0xFFFF8A80),
    isLight: false,
  );

  static final storm = WeatherPalette(
    background: _grad(0xFF16302D, 0xFF0E2220, 0xFF071412),
    blobA: const Color(0x14FFD166),
    blobB: const Color(0x1A7ED9B0),
    glassFill: const Color(0x14FFFFFF),
    glassFillSoft: const Color(0x0DFFFFFF),
    glassBorder: const Color(0x2EFFFFFF),
    glassShadow: const Color(0x66000000),
    divider: const Color(0x1AFFFFFF),
    textPrimary: const Color(0xFFFFFFFF),
    textSecondary: const Color(0xBFFFFFFF),
    textMuted: const Color(0x8CFFFFFF),
    accent: const Color(0xFF7ED9B0),
    buttonFill: const Color(0xFF1B7F5C),
    favorite: const Color(0xFFFFD166),
    error: const Color(0xFFFF8A80),
    isLight: false,
  );

  static final night = WeatherPalette(
    background: _grad(0xFF0B1F1A, 0xFF10302A, 0xFF164238),
    blobA: const Color(0x1F7ED9B0),
    blobB: const Color(0x14FFFFFF),
    glassFill: const Color(0x1AFFFFFF),
    glassFillSoft: const Color(0x12FFFFFF),
    glassBorder: const Color(0x38FFFFFF),
    glassShadow: const Color(0x59020A08),
    divider: const Color(0x1FFFFFFF),
    textPrimary: const Color(0xFFFFFFFF),
    textSecondary: const Color(0xBFFFFFFF),
    textMuted: const Color(0x8CFFFFFF),
    accent: const Color(0xFF7ED9B0),
    buttonFill: const Color(0xFF1B7F5C),
    favorite: const Color(0xFFFFD166),
    error: const Color(0xFFFF8A80),
    isLight: false,
  );

  static WeatherPalette fromMood(WeatherMood mood) => switch (mood) {
        WeatherMood.clear => clear,
        WeatherMood.partlyCloudy => partlyCloudy,
        WeatherMood.cloudy => cloudy,
        WeatherMood.rain => rain,
        WeatherMood.storm => storm,
        WeatherMood.night => night,
      };

  @override
  WeatherPalette copyWith() => this;

  /// Dipanggil otomatis oleh MaterialApp saat tema beranimasi.
  @override
  WeatherPalette lerp(ThemeExtension<WeatherPalette>? other, double t) {
    if (other is! WeatherPalette) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return WeatherPalette(
      background: LinearGradient.lerp(background, other.background, t)!,
      blobA: c(blobA, other.blobA),
      blobB: c(blobB, other.blobB),
      glassFill: c(glassFill, other.glassFill),
      glassFillSoft: c(glassFillSoft, other.glassFillSoft),
      glassBorder: c(glassBorder, other.glassBorder),
      glassShadow: c(glassShadow, other.glassShadow),
      divider: c(divider, other.divider),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textMuted: c(textMuted, other.textMuted),
      accent: c(accent, other.accent),
      buttonFill: c(buttonFill, other.buttonFill),
      favorite: c(favorite, other.favorite),
      error: c(error, other.error),
      isLight: t < 0.5 ? isLight : other.isLight,
    );
  }
}
