// lib/views/shared/loading_view.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/weather_palette.dart';
import 'glass_card.dart';

/// Tampilan state loading mengikuti desain Status Memuat Cuaca.png.
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Memuat cuaca...',
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: GlassCard(
            radius: 28,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lingkaran progres dengan ikon angin di tengah.
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: p.accent,
                          backgroundColor: p.accent.withValues(alpha: 0.16),
                        ),
                      ),
                      Icon(Icons.air, size: 28, color: p.textPrimary),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: textStyles.titleCondition
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Menyinkronkan data prakiraan terbaru...',
                  style: textStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Pill status koneksi sumber data Open-Meteo.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: p.glassFillSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.podcasts, size: 16, color: p.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Open-Meteo API',
                          style: textStyles.labelSmall
                              .copyWith(color: p.textPrimary),
                        ),
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: p.accent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sinkronisasi',
                        style: textStyles.labelSmall.copyWith(color: p.accent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
