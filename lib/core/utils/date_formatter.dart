// lib/core/utils/date_formatter.dart
import 'package:intl/intl.dart';

/// Utilitas pemformatan tanggal, hari, dan jam lokal dalam bahasa Indonesia.
class DateFormatter {
  static const List<String> _shortDays = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Mengembalikan "Hari ini" jika indeks 0, atau nama hari singkat (Sen, Sel, ...).
  static String formatForecastDay(DateTime date, {required int index}) {
    if (index == 0) return 'Hari ini';
    return _shortDays[date.weekday - 1];
  }

  /// Format tanggal singkat seperti "25 Nov".
  static String formatShortDate(DateTime date) {
    final day = DateFormat('dd').format(date);
    final month = _shortMonths[date.month - 1];
    return '$day $month';
  }

  /// Format hari dan tanggal lokal seperti "Rab, 25 Nov".
  static String formatDayAndDate(DateTime date) {
    final dayName = _shortDays[date.weekday - 1];
    return '$dayName, ${formatShortDate(date)}';
  }

  /// Format jam 24 jam seperti "14:05:09" atau "14:05".
  static String formatTime(DateTime date, {bool withSeconds = true}) {
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    if (!withSeconds) return '$hh:$mm';
    final ss = date.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  /// Mengonversi waktu UTC saat ini ke waktu lokal kota berdasarkan utcOffsetSeconds.
  static DateTime cityNow(int utcOffsetSeconds) {
    return DateTime.now().toUtc().add(Duration(seconds: utcOffsetSeconds));
  }

  /// Format label zona waktu (misalnya "WIB" atau "UTC+07:00").
  static String formatUtcOffset(int utcOffsetSeconds, {String? abbreviation}) {
    final sign = utcOffsetSeconds >= 0 ? '+' : '-';
    final absSeconds = utcOffsetSeconds.abs();
    final hours = (absSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((absSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final offsetLabel = 'UTC$sign$hours:$minutes';

    if (abbreviation != null &&
        abbreviation.trim().isNotEmpty &&
        !abbreviation.startsWith('GMT')) {
      return '$abbreviation ($offsetLabel)';
    }
    return offsetLabel;
  }
}
