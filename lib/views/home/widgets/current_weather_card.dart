// lib/views/home/widgets/current_weather_card.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../../core/utils/weather_code_mapper.dart';
import '../../../data/models/current_weather_model.dart';
import '../../../data/models/daily_forecast_model.dart';
import '../../shared/glass_card.dart';

/// Kartu hero di Home Screen; dapat ditekan untuk membuka prakiraan per jam.
class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeatherModel current;
  final DailyForecastModel? todayForecast;
  final VoidCallback? onTap;

  const CurrentWeatherCard({
    super.key,
    required this.current,
    this.todayForecast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final weatherInfo = mapWeatherCode(current.weatherCode);

    return GlassCard(
      radius: 28,
      blur: 24,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      onTap: onTap,
      child: Column(
        children: [
          // Badge status pembaruan langsung dari API.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: p.glassFillSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.accent,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'PEMBARUAN LANGSUNG',
                  style: textStyles.labelSmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: p.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            weatherInfo.icon,
            size: 88,
            color: p.isLight ? p.accent : p.textPrimary,
          ),
          const SizedBox(height: 14),
          // Animasi halus saat suhu berganti antar kota.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Row(
              key: ValueKey(current.temperature.round()),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${current.temperature.round()}',
                  style: textStyles.displayTemp,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 2),
                  child: Text(
                    '°C',
                    style: textStyles.titleCondition.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: p.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weatherInfo.label,
            style: textStyles.titleCondition.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Terasa seperti ${current.apparentTemperature.round()}°',
            style: textStyles.bodyMedium,
          ),
          if (todayForecast != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: p.glassFillSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '↑ ${todayForecast!.tempMax.round()}°   •   ↓ ${todayForecast!.tempMin.round()}°',
                style: textStyles.labelSmall.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: p.textPrimary,
                ),
              ),
            ),
          ],
          if (onTap != null) ...[
            const SizedBox(height: 16),
            Divider(color: p.divider, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule_rounded, size: 15, color: p.accent),
                const SizedBox(width: 6),
                Text(
                  'Lihat prakiraan per jam',
                  style: textStyles.labelSmall.copyWith(
                    color: p.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 18, color: p.accent),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
