// lib/views/forecast/seven_day_forecast_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/weather_palette.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/daily_forecast_model.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../shared/empty_view.dart';
import '../shared/error_view.dart';
import '../shared/glass_card.dart';
import '../shared/loading_view.dart';

/// Halaman prakiraan cuaca 7 hari menggunakan data daily yang sudah dimuat oleh WeatherViewModel.
class SevenDayForecastScreen extends StatelessWidget {
  const SevenDayForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    final textStyles = AppTextStyles.of(context);
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final location = vm.selectedLocation;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prakiraan 7 Hari', style: textStyles.titleSection),
            if (location != null)
              Text(
                location.name,
                style: textStyles.bodyMedium.copyWith(color: p.accent),
              ),
          ],
        ),
      ),
      body: SafeArea(
        child: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    if (vm.state == ViewState.loading) return const LoadingView();
    if (vm.state == ViewState.error) {
      return ErrorView(message: vm.errorMessage, onRetry: vm.refresh);
    }
    if (vm.weather == null || vm.weather!.daily.isEmpty) {
      return const EmptyView(
        icon: Icons.calendar_today_outlined,
        title: 'Data tidak tersedia',
        subtitle: 'Prakiraan harian belum tersedia untuk kota ini.',
      );
    }

    final daily = vm.weather!.daily;
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final rangeLabel = daily.length >= 2
        ? '${DateFormatter.formatShortDate(daily.first.date)} – ${DateFormatter.formatShortDate(daily.last.date)}'
        : DateFormatter.formatShortDate(daily.first.date);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        Text(rangeLabel,
            style: textStyles.bodyMedium.copyWith(color: p.accent)),
        const SizedBox(height: 14),
        GlassCard(
          radius: 24,
          blur: 18,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              for (int i = 0; i < daily.length; i++) ...[
                _DayRow(item: daily[i], index: i),
                if (i < daily.length - 1) Divider(color: p.divider, height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  final DailyForecastModel item;
  final int index;
  const _DayRow({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final info = mapWeatherCode(item.weatherCode);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormatter.formatForecastDay(item.date, index: index),
                  style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormatter.formatShortDate(item.date),
                  style: textStyles.labelSmall,
                ),
              ],
            ),
          ),
          Icon(info.icon, size: 26, color: p.isLight ? p.accent : p.textPrimary),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              info.label,
              style: textStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop_rounded, size: 13, color: p.accent),
              const SizedBox(width: 2),
              Text(
                '${item.precipitationProbabilityMax}%',
                style: textStyles.bodyMedium.copyWith(color: p.accent, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: '${item.tempMax.round()}°',
                style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: ' / ${item.tempMin.round()}°',
                style: textStyles.bodyMedium,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
