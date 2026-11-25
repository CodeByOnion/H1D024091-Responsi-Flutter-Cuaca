// lib/views/home/widgets/local_time_chip.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../../core/utils/date_formatter.dart';
import '../../shared/glass_card.dart';

/// Menampilkan jam dan tanggal lokal kota terpilih yang diperbarui tiap detik tanpa request API.
class LocalTimeChip extends StatefulWidget {
  final int? utcOffsetSeconds;
  final String? timezoneAbbreviation;

  const LocalTimeChip({
    super.key,
    required this.utcOffsetSeconds,
    this.timezoneAbbreviation,
  });

  @override
  State<LocalTimeChip> createState() => _LocalTimeChipState();
}

class _LocalTimeChipState extends State<LocalTimeChip> {
  Timer? _timer;
  late DateTime _nowUtc;

  @override
  void initState() {
    super.initState();
    _nowUtc = DateTime.now().toUtc();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _nowUtc = DateTime.now().toUtc();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final offset = widget.utcOffsetSeconds;

    if (offset == null) {
      // Fallback jika metadata zona waktu tidak tersedia dari API.
      final deviceNow = DateTime.now();
      return GlassCard(
        radius: 18,
        blur: 10,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.schedule_rounded, size: 18, color: p.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Waktu perangkat • ${DateFormatter.formatDayAndDate(deviceNow)}',
                style: textStyles.bodyMedium,
              ),
            ),
            Text(
              DateFormatter.formatTime(deviceNow),
              style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    final cityTime = _nowUtc.add(Duration(seconds: offset));
    final tzLabel = DateFormatter.formatUtcOffset(
      offset,
      abbreviation: widget.timezoneAbbreviation,
    );

    return GlassCard(
      radius: 18,
      blur: 10,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 18, color: p.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormatter.formatDayAndDate(cityTime),
                  style: textStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  tzLabel,
                  style: textStyles.labelSmall.copyWith(color: p.accent),
                ),
              ],
            ),
          ),
          Text(
            DateFormatter.formatTime(cityTime),
            style: textStyles.titleCondition.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
