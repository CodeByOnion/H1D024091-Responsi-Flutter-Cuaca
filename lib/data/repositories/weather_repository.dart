// lib/data/repositories/weather_repository.dart
import '../models/location_model.dart';
import '../models/weather_response_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

/// Repository sebagai perantara tunggal antara ViewModel dengan API dan penyimpanan lokal.
class WeatherRepository {
  final WeatherApiService apiService;
  final LocalStorageService storageService;

  WeatherRepository({
    required this.apiService,
    required this.storageService,
  });

  Future<List<LocationModel>> searchLocations(String query) {
    return apiService.searchLocations(query);
  }

  Future<WeatherResponseModel> getWeather(LocationModel location) {
    return apiService.fetchWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  Future<WeatherResponseModel> getCurrentWeather(LocationModel location) {
    return apiService.fetchCurrentWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  Future<List<LocationModel>> getFavorites() => storageService.getFavorites();

  Future<void> saveFavorites(List<LocationModel> locations) =>
      storageService.saveFavorites(locations);

  Future<List<LocationModel>> getHistory() => storageService.getHistory();

  Future<void> saveHistory(List<LocationModel> locations) =>
      storageService.saveHistory(locations);

  Future<LocationModel?> getLastLocation() => storageService.getLastLocation();

  Future<void> saveLastLocation(LocationModel location) =>
      storageService.saveLastLocation(location);
}
