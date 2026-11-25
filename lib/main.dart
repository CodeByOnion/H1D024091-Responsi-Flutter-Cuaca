// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/repositories/weather_repository.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/weather_api_service.dart';
import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi dependency sekali di root agar mudah diuji dan dijelaskan (MVVM).
  final repository = WeatherRepository(
    apiService: WeatherApiService(),
    storageService: LocalStorageService(),
  );

  runApp(
    MultiProvider(
      providers: [
        // Repository diekspos agar FavoritesScreen bisa mengaksesnya lewat Provider.of.
        Provider<WeatherRepository>.value(value: repository),
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(repository)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationViewModel(repository)..loadSavedData(),
        ),
      ],
      child: const App(),
    ),
  );
}
