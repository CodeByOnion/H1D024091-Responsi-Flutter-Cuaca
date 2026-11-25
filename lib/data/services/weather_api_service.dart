// lib/data/services/weather_api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/location_model.dart';
import '../models/weather_response_model.dart';

/// Service untuk melakukan HTTP GET ke API Open-Meteo (Geocoding & Forecast).
class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari daftar kota berdasarkan nama ke Geocoding API Open-Meteo.
  Future<List<LocationModel>> searchLocations(String query) async {
    final uri = Uri.parse(ApiConstants.geocodingBaseUrl).replace(
      queryParameters: {
        'name': query,
        'count': '${ApiConstants.geocodingCount}',
        'language': 'id',
        'format': 'json',
      },
    );

    final data = await _getJson(uri);
    // Jika tidak ada hasil, field `results` tidak ada di respons Open-Meteo.
    final results = data['results'];
    if (results is! List) return [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(LocationModel.fromJson)
        .toList();
  }

  /// Mengambil data cuaca terkini, prakiraan 7 hari, dan per jam dari Forecast API Open-Meteo.
  Future<WeatherResponseModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(ApiConstants.forecastBaseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': ApiConstants.currentParams,
        'daily': ApiConstants.dailyParams,
        'hourly': ApiConstants.hourlyParams,
        'timezone': 'auto',
        'forecast_days': '${ApiConstants.forecastDays}',
      },
    );

    final data = await _getJson(uri);
    return WeatherResponseModel.fromJson(data);
  }

  /// Mengambil hanya cuaca terkini dan metadata zona waktu (lebih ringan untuk daftar favorit).
  Future<WeatherResponseModel> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(ApiConstants.forecastBaseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': ApiConstants.currentParams,
        'timezone': 'auto',
      },
    );

    final data = await _getJson(uri);
    return WeatherResponseModel.fromJson(data);
  }

  /// Helper HTTP GET dengan timeout dan penanganan status/format JSON.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response =
          await _client.get(uri).timeout(ApiConstants.requestTimeout);

      if (response.statusCode != 200) {
        throw Exception('Server mengembalikan status ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Format respons JSON tidak valid');
      }
      return decoded;
    } on TimeoutException {
      throw Exception('Tidak dapat terhubung (waktu habis)');
    } on SocketException {
      throw Exception('Tidak dapat terhubung. Periksa koneksi internet Anda');
    } on FormatException {
      throw Exception('Gagal membaca data dari server');
    }
  }
}
