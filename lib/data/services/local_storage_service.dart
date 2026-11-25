// lib/data/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

/// Service penyimpanan lokal menggunakan SharedPreferences untuk favorit, riwayat, dan lokasi terakhir.
class LocalStorageService {
  static const String _favoritesKey = 'favorite_locations';
  static const String _historyKey = 'search_history';
  static const String _lastLocationKey = 'last_location';

  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return _decodeLocationList(prefs.getStringList(_favoritesKey));
  }

  Future<void> saveFavorites(List<LocationModel> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = locations.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_favoritesKey, encoded);
  }

  Future<List<LocationModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return _decodeLocationList(prefs.getStringList(_historyKey));
  }

  Future<void> saveHistory(List<LocationModel> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = locations.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_historyKey, encoded);
  }

  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastLocationKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return LocationModel.fromJson(decoded);
    } catch (_) {
      // Abaikan data korup agar aplikasi tidak crash.
      return null;
    }
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLocationKey, jsonEncode(location.toJson()));
  }

  /// Mengubah list JSON string menjadi list LocationModel; data korup dilewati.
  List<LocationModel> _decodeLocationList(List<String>? rawList) {
    if (rawList == null) return [];
    final List<LocationModel> result = [];
    for (final item in rawList) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        result.add(LocationModel.fromJson(map));
      } catch (_) {
        // Abaikan item JSON yang rusak.
      }
    }
    return result;
  }
}
