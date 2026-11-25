// lib/data/models/weather_response_model.dart
import 'current_weather_model.dart';
import 'daily_forecast_model.dart';
import 'hourly_forecast_model.dart';

/// Gabungan respons cuaca terkini, prakiraan harian, per jam, dan metadata zona waktu.
class WeatherResponseModel {
  final CurrentWeatherModel current;
  final List<DailyForecastModel> daily;
  final List<HourlyForecastModel> hourly;
  final String? timezone;
  final int? utcOffsetSeconds;
  final String? timezoneAbbreviation;

  const WeatherResponseModel({
    required this.current,
    required this.daily,
    this.hourly = const [],
    this.timezone,
    this.utcOffsetSeconds,
    this.timezoneAbbreviation,
  });

  /// Mengubah JSON Open-Meteo menjadi objek cuaca lengkap.
  /// Bagian `daily` dan `hourly` berbentuk array paralel per field, sehingga di-loop per indeks.
  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    final currentMap = json['current'] as Map<String, dynamic>? ?? {};
    final dailyMap = json['daily'] as Map<String, dynamic>? ?? {};
    final hourlyMap = json['hourly'] as Map<String, dynamic>? ?? {};

    // Parsing array paralel daily.
    final dailyTimes = dailyMap['time'] as List<dynamic>? ?? [];
    final dailyCodes = dailyMap['weather_code'] as List<dynamic>? ?? [];
    final maxTemps = dailyMap['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = dailyMap['temperature_2m_min'] as List<dynamic>? ?? [];
    final dailyProbs =
        dailyMap['precipitation_probability_max'] as List<dynamic>? ?? [];

    final List<DailyForecastModel> dailyList = [];
    for (int i = 0; i < dailyTimes.length; i++) {
      final date = DateTime.tryParse(dailyTimes[i].toString());
      if (date == null) continue;

      dailyList.add(
        DailyForecastModel(
          date: date,
          weatherCode: i < dailyCodes.length && dailyCodes[i] != null
              ? (dailyCodes[i] as num).toInt()
              : 0,
          tempMax: i < maxTemps.length && maxTemps[i] != null
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          tempMin: i < minTemps.length && minTemps[i] != null
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          precipitationProbabilityMax:
              i < dailyProbs.length && dailyProbs[i] != null
                  ? (dailyProbs[i] as num).toInt()
                  : 0,
        ),
      );
    }

    // Parsing array paralel hourly.
    final hourlyTimes = hourlyMap['time'] as List<dynamic>? ?? [];
    final hourlyTemps = hourlyMap['temperature_2m'] as List<dynamic>? ?? [];
    final hourlyCodes = hourlyMap['weather_code'] as List<dynamic>? ?? [];
    final hourlyProbs =
        hourlyMap['precipitation_probability'] as List<dynamic>? ?? [];

    final List<HourlyForecastModel> hourlyList = [];
    for (int i = 0; i < hourlyTimes.length; i++) {
      final dateTime = DateTime.tryParse(hourlyTimes[i].toString());
      if (dateTime == null) continue;

      hourlyList.add(
        HourlyForecastModel(
          dateTime: dateTime,
          temperature: i < hourlyTemps.length && hourlyTemps[i] != null
              ? (hourlyTemps[i] as num).toDouble()
              : 0.0,
          weatherCode: i < hourlyCodes.length && hourlyCodes[i] != null
              ? (hourlyCodes[i] as num).toInt()
              : 0,
          precipitationProbability:
              i < hourlyProbs.length && hourlyProbs[i] != null
                  ? (hourlyProbs[i] as num).toInt()
                  : 0,
        ),
      );
    }
    hourlyList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return WeatherResponseModel(
      current: CurrentWeatherModel.fromJson(currentMap),
      daily: dailyList,
      hourly: hourlyList,
      timezone: json['timezone'] as String?,
      utcOffsetSeconds: (json['utc_offset_seconds'] as num?)?.toInt(),
      timezoneAbbreviation: json['timezone_abbreviation'] as String?,
    );
  }
}
