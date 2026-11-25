// lib/data/models/location_model.dart

/// Model data kota/lokasi dari Open-Meteo Geocoding API dan penyimpanan lokal.
class LocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? timezone;

  const LocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.timezone,
  });

  /// Mengubah JSON dari API atau SharedPreferences menjadi LocationModel.
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '-',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  /// Mengubah LocationModel ke Map agar bisa disimpan sebagai JSON string.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'timezone': timezone,
    };
  }

  /// Subjudul lokasi gabungan wilayah dan negara, misalnya "Jawa Tengah, Indonesia".
  String get subtitle {
    final parts = <String>[
      if (admin1 != null && admin1!.trim().isNotEmpty) admin1!.trim(),
      if (country != null && country!.trim().isNotEmpty) country!.trim(),
    ];
    return parts.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
