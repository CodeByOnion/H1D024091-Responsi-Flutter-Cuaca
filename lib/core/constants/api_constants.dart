// lib/core/constants/api_constants.dart

/// Konstanta endpoint dan parameter Open-Meteo (tanpa API key).
class ApiConstants {
  static const String geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String forecastBaseUrl =
      'https://api.open-meteo.com/v1/forecast';

  static const Duration requestTimeout = Duration(seconds: 10);

  static const String currentParams =
      'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,is_day';

  static const String dailyParams =
      'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max';

  static const String hourlyParams =
      'temperature_2m,weather_code,precipitation_probability';

  static const int forecastDays = 7;
  static const int geocodingCount = 10;
}
