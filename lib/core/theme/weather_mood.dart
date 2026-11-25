// lib/core/theme/weather_mood.dart

/// Mood visual aplikasi yang mengikuti kondisi cuaca dari API.
enum WeatherMood { clear, partlyCloudy, cloudy, rain, storm, night }

/// Fungsi murni: memetakan weather_code (WMO) ke WeatherMood.
/// Tema selalu mengikuti kondisi cuaca aktual (bukan tertukar karena siang/malam).
WeatherMood moodFromWeatherCode(int code, {bool isDay = true}) {
  switch (code) {
    // Cerah / hampir cerah -> Sunny (Terang)
    case 0:
    case 1:
      return WeatherMood.clear;

    // Berawan sebagian, mendung, kabut, dan salju -> Cloudy (Agak redup / sejuk)
    case 2:
    case 3:
    case 45:
    case 48:
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return WeatherMood.cloudy;

    // Gerimis, hujan, dan hujan lokal -> Rain (Gelap)
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return WeatherMood.rain;

    // Badai petir -> Storm (Varian gelap dramatis untuk Rain Theme)
    case 95:
    case 96:
    case 99:
      return WeatherMood.storm;

    // Fallback aman jika kode WMO tidak dikenal
    default:
      return WeatherMood.cloudy;
  }
}
