// lib/data/models/current_weather_model.dart

/// Model cuaca terkini dari field `current` pada Open-Meteo Forecast API.
class CurrentWeatherModel {
  final double temperature;
  final int humidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final bool isDay;

  const CurrentWeatherModel({
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    this.isDay = true,
  });

  /// Parsing JSON `current` dengan nilai default aman jika ada field null.
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      isDay: (json['is_day'] as num?)?.toInt() != 0,
    );
  }
}
