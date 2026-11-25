// lib/viewmodels/favorites_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../data/models/location_model.dart';
import '../data/models/weather_response_model.dart';
import '../data/repositories/weather_repository.dart';
import 'weather_viewmodel.dart';

/// Status cuaca independen per kota favorit.
class FavoriteItemState {
  final LocationModel location;
  final ViewState state;
  final WeatherResponseModel? weather;
  final String errorMessage;

  const FavoriteItemState({
    required this.location,
    required this.state,
    this.weather,
    this.errorMessage = '',
  });

  FavoriteItemState copyWith({
    ViewState? state,
    WeatherResponseModel? weather,
    String? errorMessage,
  }) {
    return FavoriteItemState(
      location: location,
      state: state ?? this.state,
      weather: weather ?? this.weather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// ViewModel untuk halaman Favorit: memuat cuaca per kota dengan state independen.
class FavoritesViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  FavoritesViewModel(this._repository);

  List<FavoriteItemState> _items = [];

  List<FavoriteItemState> get items => _items;

  /// Memuat daftar favorit dari storage lalu mengambil cuaca tiap kota dari API.
  Future<void> loadFavorites() async {
    final favLocations = await _repository.getFavorites();
    _items = favLocations
        .map((loc) => FavoriteItemState(location: loc, state: ViewState.loading))
        .toList();
    notifyListeners();

    // Muat cuaca tiap kota secara paralel; satu kota gagal tidak mengganggu kota lain.
    final futures = _items.map((item) => _loadWeatherFor(item.location));
    await Future.wait(futures);
  }

  Future<void> _loadWeatherFor(LocationModel location) async {
    try {
      // Gunakan endpoint current-only agar lebih ringan.
      final result = await _repository.getCurrentWeather(location);
      _updateItem(location, ViewState.success, weather: result);
    } catch (e) {
      _updateItem(
        location,
        ViewState.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void _updateItem(LocationModel location, ViewState state,
      {WeatherResponseModel? weather, String? errorMessage}) {
    _items = _items.map((item) {
      if (item.location == location) {
        return item.copyWith(
          state: state,
          weather: weather,
          errorMessage: errorMessage,
        );
      }
      return item;
    }).toList();
    notifyListeners();
  }

  /// Coba lagi memuat cuaca untuk satu kota yang sebelumnya gagal.
  Future<void> retryItem(LocationModel location) async {
    _updateItem(location, ViewState.loading);
    await _loadWeatherFor(location);
  }

  /// Refresh seluruh daftar favorit dari storage dan muat ulang cuaca.
  Future<void> refresh() async {
    await loadFavorites();
  }

  /// Menghapus kota dari daftar favorit dan menyimpannya ke storage.
  Future<void> removeFavorite(LocationModel location) async {
    final remaining = _items
        .where((item) => item.location != location)
        .map((item) => item.location)
        .toList();
    await _repository.saveFavorites(remaining);
    _items = _items.where((item) => item.location != location).toList();
    notifyListeners();
  }
}
