// lib/viewmodels/weather_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../core/theme/weather_mood.dart';
import '../core/theme/weather_palette.dart';
import '../core/utils/date_formatter.dart';
import '../data/models/hourly_forecast_model.dart';
import '../data/models/location_model.dart';
import '../data/models/weather_response_model.dart';
import '../data/repositories/weather_repository.dart';

/// Status tampilan umum yang dipakai View untuk merender loading/empty/error/success.
enum ViewState { initial, loading, success, empty, error }

/// ViewModel utama untuk cuaca kota terpilih dan mood tema adaptif.
class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  /// Lokasi default jika belum ada lokasi terakhir di storage (hanya koordinat, bukan data cuaca).
  static const LocationModel defaultLocation = LocationModel(
    id: 1630328,
    name: 'Purwokerto',
    latitude: -7.42139,
    longitude: 109.23444,
    country: 'Indonesia',
    admin1: 'Jawa Tengah',
    timezone: 'Asia/Jakarta',
  );

  WeatherViewModel(this._repository);

  ViewState _state = ViewState.initial;
  LocationModel? _selectedLocation;
  WeatherResponseModel? _weather;
  String _errorMessage = '';
  WeatherMood _mood = WeatherMood.clear;
  int _requestId = 0;

  ViewState get state => _state;
  LocationModel? get selectedLocation => _selectedLocation;
  WeatherResponseModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  WeatherMood get mood => _mood;
  WeatherPalette get palette => WeatherPalette.fromMood(_mood);

  /// Daftar prakiraan per jam mulai dari jam berjalan di kota terpilih (maksimal 48 jam).
  List<HourlyForecastModel> get upcomingHourly {
    final currentWeather = _weather;
    if (currentWeather == null || currentWeather.hourly.isEmpty) return [];

    final offset = currentWeather.utcOffsetSeconds ?? 0;
    final cityNow = DateFormatter.cityNow(offset);
    final currentHourFloor = DateTime.utc(
      cityNow.year,
      cityNow.month,
      cityNow.day,
      cityNow.hour,
    );

    final filtered = currentWeather.hourly.where((item) {
      final itemUtcWall = DateTime.utc(
        item.dateTime.year,
        item.dateTime.month,
        item.dateTime.day,
        item.dateTime.hour,
      );
      return !itemUtcWall.isBefore(currentHourFloor);
    }).toList();

    if (filtered.isEmpty) {
      return currentWeather.hourly.take(48).toList();
    }
    return filtered.take(48).toList();
  }

  /// Dipanggil saat aplikasi mulai: muat lokasi terakhir atau lokasi default.
  Future<void> init() async {
    final savedLocation = await _repository.getLastLocation();
    await loadWeather(savedLocation ?? defaultLocation);
  }

  /// Mengambil data cuaca dari API untuk lokasi tertentu.
  Future<void> loadWeather(LocationModel location) async {
    final currentRequest = ++_requestId;
    final isDifferentCity = _selectedLocation != location;
    _selectedLocation = location;
    if (isDifferentCity) {
      // Bersihkan data kota lama agar tidak tertinggal saat berpindah kota.
      _weather = null;
    }
    _state = ViewState.loading;
    _errorMessage = '';
    // Mood sengaja tidak diubah saat loading agar warna latar tidak berkedip.
    notifyListeners();

    try {
      final result = await _repository.getWeather(location);
      if (currentRequest != _requestId) return;

      await _repository.saveLastLocation(location);
      _weather = result;
      _mood = moodFromWeatherCode(
        result.current.weatherCode,
        isDay: result.current.isDay,
      );
      _state = ViewState.success;
      notifyListeners();
    } catch (e) {
      if (currentRequest != _requestId) return;

      _state = ViewState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  /// Memuat ulang cuaca untuk lokasi yang sedang terpilih (pull-to-refresh / coba lagi).
  Future<void> refresh() async {
    if (_selectedLocation == null) return;
    await loadWeather(_selectedLocation!);
  }
}
