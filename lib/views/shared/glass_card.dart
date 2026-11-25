// lib/views/shared/glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/weather_palette.dart';

/// Komponen kartu kaca (glassmorphism) yang warnanya mengikuti WeatherPalette aktif.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final Color? fill;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 24,
    this.blur = 18,
    this.fill,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: p.glassShadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(
            color: fill ?? p.glassFill,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white.withValues(alpha: 0.2),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: p.glassBorder, width: 1),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
