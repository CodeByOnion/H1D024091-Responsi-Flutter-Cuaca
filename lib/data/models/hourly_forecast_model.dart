// lib/data/models/hourly_forecast_model.dart

/// Model prakiraan cuaca per jam dari field `hourly` pada Open-Meteo Forecast API.
class HourlyForecastModel {
  final DateTime dateTime;
  final double temperature;
  final int weatherCode;
  final int precipitationProbability;

  const HourlyForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.weatherCode,
    required this.precipitationProbability,
  });
}
