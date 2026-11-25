// lib/views/home/widgets/daily_forecast_list.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/weather_code_mapper.dart';
import '../../../data/models/daily_forecast_model.dart';
import '../../shared/glass_card.dart';

/// Ringkasan prakiraan 3 hari di Home Screen beserta tombol menuju halaman 7 hari.
class DailyForecastList extends StatelessWidget {
  final List<DailyForecastModel> daily;
  final VoidCallback onSeeSevenDays;

  const DailyForecastList({
    super.key,
    required this.daily,
    required this.onSeeSevenDays,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    // Home hanya menampilkan maksimal 3 hari pertama; data lengkap tetap utuh di ViewModel.
    final previewItems = daily.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Prakiraan 3 Hari', style: textStyles.titleSection),
            Text(
              'Ringkasan',
              style: textStyles.labelSmall.copyWith(
                color: p.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          radius: 24,
          blur: 18,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: previewItems.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Data prakiraan harian tidak tersedia.',
                      style: textStyles.bodyMedium,
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (int i = 0; i < previewItems.length; i++) ...[
                      _ForecastRow(item: previewItems[i], index: i),
                      if (i < previewItems.length - 1)
                        Divider(color: p.divider, height: 1),
                    ],
                    Divider(color: p.divider, height: 1),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: onSeeSevenDays,
                        icon: Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: p.accent,
                        ),
                        label: Text(
                          'Lihat prakiraan 7 hari',
                          style: textStyles.bodyMedium.copyWith(
                            color: p.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final DailyForecastModel item;
  final int index;

  const _ForecastRow({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final info = mapWeatherCode(item.weatherCode);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.formatForecastDay(item.date, index: index),
                    style: textStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${DateFormatter.formatShortDate(item.date)} • ${info.label}',
                    style: textStyles.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              info.icon,
              size: 24,
              color: p.isLight ? p.accent : p.textPrimary,
            ),
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.water_drop_rounded, size: 14, color: p.accent),
                const SizedBox(width: 2),
                Text(
                  '${item.precipitationProbabilityMax}%',
                  style: textStyles.bodyMedium.copyWith(
                    color: p.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${item.tempMax.round()}°',
                    style: textStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: ' / ${item.tempMin.round()}°',
                    style: textStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
