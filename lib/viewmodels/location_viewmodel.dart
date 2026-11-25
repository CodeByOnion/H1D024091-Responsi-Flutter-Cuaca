// lib/viewmodels/location_viewmodel.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/location_model.dart';
import '../data/repositories/weather_repository.dart';
import 'weather_viewmodel.dart';

/// ViewModel untuk pencarian kota (Geocoding API), daftar favorit, dan riwayat pencarian.
class LocationViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  static const int _maxHistory = 10;

  LocationViewModel(this._repository);

  ViewState _searchState = ViewState.initial;
  List<LocationModel> _results = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _history = [];
  String _errorMessage = '';
  String _query = '';
  Timer? _debounce;

  ViewState get searchState => _searchState;
  List<LocationModel> get results => _results;
  List<LocationModel> get favorites => _favorites;
  List<LocationModel> get history => _history;
  String get errorMessage => _errorMessage;
  String get query => _query;

  /// Memuat favorit dan riwayat dari SharedPreferences saat aplikasi dibuka.
  Future<void> loadSavedData() async {
    _favorites = await _repository.getFavorites();
    _history = await _repository.getHistory();
    notifyListeners();
  }

  /// Menjalankan pencarian kota dengan debounce 500 ms agar tidak spam API.
  void search(String query) {
    _query = query;
    _debounce?.cancel();

    final trimmed = query.trim();
    if (trimmed.length < 2) {
      _results = [];
      _searchState = ViewState.initial;
      _errorMessage = '';
      notifyListeners();
      return;
    }

    _searchState = ViewState.loading;
    _errorMessage = '';
    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(trimmed);
    });
  }

  Future<void> _performSearch(String trimmedQuery) async {
    try {
      final fetched = await _repository.searchLocations(trimmedQuery);
      // Abaikan hasil jika user sudah mengetik query baru.
      if (trimmedQuery != _query.trim()) return;

      if (fetched.isEmpty) {
        _results = [];
        _searchState = ViewState.empty;
      } else {
        _results = fetched;
        _searchState = ViewState.success;
      }
      notifyListeners();
    } catch (e) {
      if (trimmedQuery != _query.trim()) return;

      _results = [];
      _searchState = ViewState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  /// Mengulang pencarian terakhir saat terjadi error jaringan.
  Future<void> retrySearch() async {
    final trimmed = _query.trim();
    if (trimmed.length < 2) return;
    _searchState = ViewState.loading;
    _errorMessage = '';
    notifyListeners();
    await _performSearch(trimmed);
  }

  /// Mengosongkan input dan hasil pencarian.
  void clearResults() {
    _debounce?.cancel();
    _query = '';
    _results = [];
    _searchState = ViewState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  bool isFavorite(LocationModel location) => _favorites.contains(location);

  /// Menambah atau menghapus lokasi dari daftar favorit dan langsung menyimpannya.
  Future<void> toggleFavorite(LocationModel location) async {
    if (isFavorite(location)) {
      _favorites = _favorites.where((item) => item != location).toList();
    } else {
      _favorites = [location, ..._favorites];
    }
    notifyListeners();
    await _repository.saveFavorites(_favorites);
  }

  /// Menyimpan lokasi ke riwayat pencarian (maksimal 10 item, tanpa duplikat, terbaru di atas).
  Future<void> addToHistory(LocationModel location) async {
    final updated = [
      location,
      ..._history.where((item) => item != location),
    ];
    _history = updated.take(_maxHistory).toList();
    notifyListeners();
    await _repository.saveHistory(_history);
  }

  /// Menghapus seluruh riwayat pencarian.
  Future<void> clearHistory() async {
    _history = [];
    notifyListeners();
    await _repository.saveHistory(_history);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
