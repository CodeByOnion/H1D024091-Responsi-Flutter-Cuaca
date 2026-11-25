// lib/data/models/daily_forecast_model.dart

/// Model prakiraan cuaca harian (1 baris untuk 1 hari).
class DailyForecastModel {
  final DateTime date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final int precipitationProbabilityMax;

  const DailyForecastModel({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbabilityMax,
  });
}
