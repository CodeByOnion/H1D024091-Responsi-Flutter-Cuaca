// lib/views/shared/gradient_background.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/weather_palette.dart';

/// Latar gradien adaptif + dua blob blur lembut, dipasang sekali di root app.
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    return Container(
      decoration: BoxDecoration(gradient: p.background),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: _Blob(color: p.blobA, size: 260),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: _Blob(color: p.blobB, size: 300),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
