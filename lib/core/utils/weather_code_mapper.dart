// lib/core/utils/weather_code_mapper.dart
import 'package:flutter/material.dart';

/// Hasil pemetaan weather_code WMO ke label bahasa Indonesia dan ikon Material.
class WeatherCodeInfo {
  final String label;
  final IconData icon;

  const WeatherCodeInfo(this.label, this.icon);
}

/// Memetakan kode cuaca WMO dari Open-Meteo menjadi label dan ikon.
WeatherCodeInfo mapWeatherCode(int code) {
  switch (code) {
    case 0:
      return const WeatherCodeInfo('Cerah', Icons.wb_sunny);
    case 1:
    case 2:
      return const WeatherCodeInfo('Cerah berawan', Icons.cloud_queue);
    case 3:
      return const WeatherCodeInfo('Berawan', Icons.cloud);
    case 45:
    case 48:
      return const WeatherCodeInfo('Berkabut', Icons.foggy);
    case 51:
    case 53:
    case 55:
      return const WeatherCodeInfo('Gerimis', Icons.grain);
    case 56:
    case 57:
      return const WeatherCodeInfo('Gerimis beku', Icons.grain);
    case 61:
    case 63:
    case 65:
      return const WeatherCodeInfo('Hujan', Icons.water_drop);
    case 66:
    case 67:
      return const WeatherCodeInfo('Hujan beku', Icons.water_drop);
    case 71:
    case 73:
    case 75:
    case 77:
      return const WeatherCodeInfo('Salju', Icons.ac_unit);
    case 80:
    case 81:
    case 82:
      return const WeatherCodeInfo('Hujan lebat sesaat', Icons.water_drop);
    case 85:
    case 86:
      return const WeatherCodeInfo('Hujan salju sesaat', Icons.ac_unit);
    case 95:
      return const WeatherCodeInfo('Badai petir', Icons.thunderstorm);
    case 96:
    case 99:
      return const WeatherCodeInfo('Badai petir + es', Icons.thunderstorm);
    default:
      return const WeatherCodeInfo('Tidak diketahui', Icons.help_outline);
  }
}
