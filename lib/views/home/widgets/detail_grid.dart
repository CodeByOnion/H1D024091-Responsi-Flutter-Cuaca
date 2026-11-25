// lib/views/home/widgets/detail_grid.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../../data/models/current_weather_model.dart';
import '../../shared/glass_card.dart';

/// Grid kartu detail cuaca hari ini (kelembapan, angin, peluang hujan, curah hujan).
class DetailGrid extends StatelessWidget {
  final CurrentWeatherModel current;
  final int precipitationProbability;

  const DetailGrid({
    super.key,
    required this.current,
    required this.precipitationProbability,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Detail Hari Ini', style: textStyles.titleSection),
            Text(
              'Kondisi Terkini',
              style: textStyles.labelSmall.copyWith(
                color: p.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                label: 'Kelembapan',
                icon: Icons.water_drop_rounded,
                value: '${current.humidity}',
                unit: '%',
                progress: (current.humidity / 100).clamp(0.0, 1.0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DetailCard(
                label: 'Kecepatan Angin',
                icon: Icons.air_rounded,
                value: '${current.windSpeed.round()}',
                unit: 'km/j',
                caption: 'Kecepatan saat ini',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                label: 'Peluang Hujan',
                icon: Icons.umbrella_rounded,
                value: '$precipitationProbability',
                unit: '%',
                caption: precipitationProbability >= 60
                    ? 'Potensi tinggi'
                    : 'Relatif rendah',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DetailCard(
                label: 'Curah Hujan',
                icon: Icons.grain_rounded,
                value: current.precipitation.toStringAsFixed(1),
                unit: 'mm',
                caption: current.precipitation > 0
                    ? 'Ada presipitasi'
                    : 'Tanpa presipitasi',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String unit;
  final String? caption;
  final double? progress;

  const _DetailCard({
    required this.label,
    required this.icon,
    required this.value,
    required this.unit,
    this.caption,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return GlassCard(
      radius: 22,
      blur: 18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textStyles.bodyMedium.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 20, color: p.accent),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: textStyles.valueDetail),
              const SizedBox(width: 4),
              Text(unit, style: textStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 10),
          if (progress != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                color: p.accent,
                backgroundColor: p.divider,
              ),
            )
          else if (caption != null)
            Text(
              caption!,
              style: textStyles.labelSmall.copyWith(
                color: p.accent,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
