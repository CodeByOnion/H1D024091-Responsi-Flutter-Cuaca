// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:awanara/core/theme/weather_mood.dart';
import 'package:awanara/core/theme/weather_palette.dart';
import 'package:awanara/data/models/current_weather_model.dart';
import 'package:awanara/data/models/location_model.dart';
import 'package:awanara/data/models/weather_response_model.dart';
import 'package:awanara/data/repositories/weather_repository.dart';
import 'package:awanara/data/services/local_storage_service.dart';
import 'package:awanara/data/services/weather_api_service.dart';
import 'package:awanara/viewmodels/weather_viewmodel.dart';

/// Repository tiruan untuk menguji alur pembaruan tema pada WeatherViewModel.
class _FakeWeatherRepository extends WeatherRepository {
  _FakeWeatherRepository()
      : super(
          apiService: WeatherApiService(),
          storageService: LocalStorageService(),
        );

  final Map<int, WeatherResponseModel> responses = {};
  bool shouldFail = false;

  @override
  Future<WeatherResponseModel> getWeather(LocationModel location) async {
    if (shouldFail) {
      throw Exception('Koneksi gagal');
    }
    return responses[location.id]!;
  }

  @override
  Future<void> saveLastLocation(LocationModel location) async {}

  @override
  Future<LocationModel?> getLastLocation() async => null;
}

WeatherResponseModel _makeWeather(int weatherCode, {bool isDay = true}) {
  return WeatherResponseModel(
    current: CurrentWeatherModel(
      temperature: 28,
      humidity: 75,
      apparentTemperature: 30,
      precipitation: 0,
      weatherCode: weatherCode,
      windSpeed: 10,
      isDay: isDay,
    ),
    daily: const [],
  );
}

void main() {
  group('Adaptive Weather Theme - moodFromWeatherCode', () {
    test('Kode 0 dan 1 memetakan ke Sunny (clear) baik siang maupun malam', () {
      expect(moodFromWeatherCode(0, isDay: true), WeatherMood.clear);
      expect(moodFromWeatherCode(0, isDay: false), WeatherMood.clear);
      expect(moodFromWeatherCode(1, isDay: true), WeatherMood.clear);
      expect(moodFromWeatherCode(1, isDay: false), WeatherMood.clear);
    });

    test('Kode 2, 3, 45, 48 memetakan ke Cloudy (agak redup)', () {
      expect(moodFromWeatherCode(2, isDay: true), WeatherMood.cloudy);
      expect(moodFromWeatherCode(2, isDay: false), WeatherMood.cloudy);
      expect(moodFromWeatherCode(3, isDay: true), WeatherMood.cloudy);
      expect(moodFromWeatherCode(45, isDay: true), WeatherMood.cloudy);
      expect(moodFromWeatherCode(48, isDay: true), WeatherMood.cloudy);
    });

    test('Kode hujan (51, 61, 65, 80) memetakan ke Rain (gelap)', () {
      expect(moodFromWeatherCode(51, isDay: true), WeatherMood.rain);
      expect(moodFromWeatherCode(61, isDay: true), WeatherMood.rain);
      expect(moodFromWeatherCode(65, isDay: true), WeatherMood.rain);
      expect(moodFromWeatherCode(80, isDay: true), WeatherMood.rain);
    });

    test('Kode salju (71) dan badai petir (95) konsisten dengan tema yang ada', () {
      expect(moodFromWeatherCode(71, isDay: true), WeatherMood.cloudy);
      expect(moodFromWeatherCode(95, isDay: true), WeatherMood.storm);
    });

    test('Kode tidak dikenal memiliki fallback aman ke cloudy', () {
      expect(moodFromWeatherCode(-1, isDay: true), WeatherMood.cloudy);
      expect(moodFromWeatherCode(999, isDay: false), WeatherMood.cloudy);
    });

    test('Kecerahan WeatherPalette konsisten: Sunny terang, Cloudy/Rain gelap', () {
      expect(WeatherPalette.fromMood(WeatherMood.clear).isLight, isTrue);
      expect(WeatherPalette.fromMood(WeatherMood.cloudy).isLight, isFalse);
      expect(WeatherPalette.fromMood(WeatherMood.rain).isLight, isFalse);
      expect(WeatherPalette.fromMood(WeatherMood.storm).isLight, isFalse);
    });
  });

  group('WeatherViewModel - Pembaruan Tema Adaptif', () {
    const cityA = LocationModel(
      id: 1,
      name: 'Purwokerto',
      latitude: -7.42,
      longitude: 109.23,
    );
    const cityB = LocationModel(
      id: 2,
      name: 'Jakarta',
      latitude: -6.17,
      longitude: 106.82,
    );

    test('Tema berubah saat lokasi berganti, refresh, dan aman saat error', () async {
      final repo = _FakeWeatherRepository();
      repo.responses[1] = _makeWeather(0, isDay: false); // Cerah saat malam
      repo.responses[2] = _makeWeather(61); // Hujan ringan

      final vm = WeatherViewModel(repo);

      // 1. Lokasi A (cerah) -> harus Sunny (clear)
      await vm.loadWeather(cityA);
      expect(vm.state, ViewState.success);
      expect(vm.mood, WeatherMood.clear);
      expect(vm.palette.isLight, isTrue);

      // 2. Pindah ke Lokasi B (hujan) -> harus Rain
      await vm.loadWeather(cityB);
      expect(vm.state, ViewState.success);
      expect(vm.mood, WeatherMood.rain);
      expect(vm.palette.isLight, isFalse);

      // 3. Refresh Lokasi B dengan kondisi baru (berawan sebagian = 2) -> harus Cloudy
      repo.responses[2] = _makeWeather(2);
      await vm.refresh();
      expect(vm.state, ViewState.success);
      expect(vm.mood, WeatherMood.cloudy);

      // 4. Error state tidak mengubah mood yang salah/tertukar
      repo.shouldFail = true;
      await vm.refresh();
      expect(vm.state, ViewState.error);
      expect(vm.mood, WeatherMood.cloudy);
    });
  });

  test('LocationModel.fromJson dan toJson bekerja dengan benar', () {
    final json = {
      'id': 1642911,
      'name': 'Jakarta',
      'latitude': -6.17,
      'longitude': 106.82,
      'country': 'Indonesia',
      'admin1': 'Jakarta',
      'timezone': 'Asia/Jakarta',
    };

    final loc = LocationModel.fromJson(json);
    expect(loc.id, 1642911);
    expect(loc.name, 'Jakarta');
    expect(loc.subtitle, 'Jakarta, Indonesia');
    expect(LocationModel.fromJson(loc.toJson()), loc);
  });

  test('WeatherResponseModel.fromJson mem-parsing array paralel daily', () {
    final json = {
      'current': {
        'temperature_2m': 29.5,
        'relative_humidity_2m': 75,
        'apparent_temperature': 32.0,
        'precipitation': 0.2,
        'weather_code': 2,
        'wind_speed_10m': 11.4,
        'is_day': 1,
      },
      'daily': {
        'time': ['2026-11-25', '2026-11-26'],
        'weather_code': [2, 61],
        'temperature_2m_max': [32.0, 29.0],
        'temperature_2m_min': [24.0, 23.0],
        'precipitation_probability_max': [20, 80],
      },
    };

    final weather = WeatherResponseModel.fromJson(json);
    expect(weather.current.temperature, 29.5);
    expect(weather.current.weatherCode, 2);
    expect(weather.daily.length, 2);
    expect(weather.daily[1].precipitationProbabilityMax, 80);
  });
}
