// lib/views/hourly/hourly_forecast_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/weather_palette.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/hourly_forecast_model.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../shared/empty_view.dart';
import '../shared/error_view.dart';
import '../shared/glass_card.dart';
import '../shared/loading_view.dart';

/// Halaman prakiraan cuaca per jam (24–48 jam) dengan grafik suhu CustomPainter.
class HourlyForecastScreen extends StatefulWidget {
  const HourlyForecastScreen({super.key});

  @override
  State<HourlyForecastScreen> createState() => _HourlyForecastScreenState();
}

class _HourlyForecastScreenState extends State<HourlyForecastScreen> {
  int _rangeHours = 24;

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
            Text('Prakiraan Per Jam', style: textStyles.titleSection),
            if (location != null)
              Text(
                location.name,
                style: textStyles.bodyMedium.copyWith(color: p.accent),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                _RangeChip(
                  label: '24j',
                  hours: 24,
                  selected: _rangeHours == 24,
                  onTap: () => setState(() => _rangeHours = 24),
                ),
                const SizedBox(width: 8),
                _RangeChip(
                  label: '48j',
                  hours: 48,
                  selected: _rangeHours == 48,
                  onTap: () => setState(() => _rangeHours = 48),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, vm)),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    if (vm.state == ViewState.loading) {
      return const LoadingView(message: 'Memuat prakiraan per jam...');
    }
    if (vm.state == ViewState.error) {
      return ErrorView(message: vm.errorMessage, onRetry: vm.refresh);
    }

    final hourly = vm.upcomingHourly.take(_rangeHours).toList();
    if (hourly.isEmpty) {
      return const EmptyView(
        icon: Icons.schedule_outlined,
        title: 'Data per jam tidak tersedia',
        subtitle: 'Coba pilih kota lain atau refresh data.',
      );
    }

    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final offset = vm.weather?.utcOffsetSeconds ?? 0;
    final nowCity = DateFormatter.cityNow(offset);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        Text(
          'Prakiraan $_rangeHours jam ke depan',
          style: textStyles.bodyMedium.copyWith(color: p.accent),
        ),
        const SizedBox(height: 14),
        // Grafik suhu sederhana menggunakan CustomPainter.
        if (hourly.length >= 2) ...[
          GlassCard(
            radius: 20,
            blur: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SizedBox(
              height: 90,
              child: CustomPaint(
                painter: _TempChartPainter(hourly, p),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        GlassCard(
          radius: 24,
          blur: 18,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              for (int i = 0; i < hourly.length; i++) ...[
                _HourRow(
                  item: hourly[i],
                  utcOffsetSeconds: offset,
                  nowCity: nowCity,
                ),
                if (i < hourly.length - 1) Divider(color: p.divider, height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final int hours;
  final bool selected;
  final VoidCallback onTap;
  const _RangeChip({
    required this.label,
    required this.hours,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? p.accent : p.glassFillSoft,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppTextStyles.of(context).labelSmall.copyWith(
            color: selected ? Colors.white : p.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _HourRow extends StatelessWidget {
  final HourlyForecastModel item;
  final int utcOffsetSeconds;
  final DateTime nowCity;

  const _HourRow({
    required this.item,
    required this.utcOffsetSeconds,
    required this.nowCity,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final info = mapWeatherCode(item.weatherCode);

    // Jam lokal kota: tambahkan UTC offset ke waktu naif dari array hourly.
    final localTime = item.dateTime.toUtc().add(
      Duration(seconds: utcOffsetSeconds),
    );
    final isNow =
        localTime.hour == nowCity.hour &&
        localTime.day == nowCity.day &&
        localTime.month == nowCity.month;

    // Penanda pergantian hari.
    final isStartOfDay = localTime.hour == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNow
                      ? 'Skrg'
                      : DateFormatter.formatTime(localTime, withSeconds: false),
                  style: textStyles.bodyMedium.copyWith(
                    fontWeight: isNow ? FontWeight.w700 : FontWeight.w400,
                    color: isNow ? p.accent : p.textPrimary,
                  ),
                ),
                if (isStartOfDay && !isNow)
                  Text(
                    DateFormatter.formatShortDate(localTime),
                    style: textStyles.labelSmall,
                  ),
              ],
            ),
          ),
          Icon(
            info.icon,
            size: 22,
            color: p.isLight ? p.accent : p.textPrimary,
          ),
          const SizedBox(width: 10),
          Expanded(
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
                '${item.precipitationProbability}%',
                style: textStyles.bodyMedium.copyWith(color: p.accent),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Text(
            '${item.temperature.round()}°',
            style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Grafik garis suhu sederhana menggunakan CustomPainter (tanpa dependency baru).
class _TempChartPainter extends CustomPainter {
  final List<HourlyForecastModel> items;
  final WeatherPalette p;
  _TempChartPainter(this.items, this.p);

  @override
  void paint(Canvas canvas, Size size) {
    if (items.length < 2) return;

    final temps = items.map((e) => e.temperature).toList();
    final tMin = temps.reduce((a, b) => a < b ? a : b);
    final tMax = temps.reduce((a, b) => a > b ? a : b);
    final tRange = (tMax - tMin).clamp(1.0, double.infinity);

    double tx(int i) => i * size.width / (items.length - 1);
    double ty(double t) =>
        size.height - ((t - tMin) / tRange) * (size.height - 20) - 10;

    final linePaint = Paint()
      ..color = p.accent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          p.accent.withValues(alpha: 0.3),
          p.accent.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final linePath = Path();
    final fillPath = Path();

    for (int i = 0; i < items.length; i++) {
      final x = tx(i);
      final y = ty(items[i].temperature);
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(tx(items.length - 1), size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    // Titik suhu min dan maks.
    final dotPaint = Paint()
      ..color = p.accent
      ..style = PaintingStyle.fill;
    for (int i = 0; i < items.length; i++) {
      if (items[i].temperature == tMax || items[i].temperature == tMin) {
        canvas.drawCircle(Offset(tx(i), ty(items[i].temperature)), 4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_TempChartPainter oldDelegate) =>
      oldDelegate.items != items;
}
