// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/weather_palette.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home/home_screen.dart';
import 'views/shared/gradient_background.dart';

/// Root widget aplikasi AWANARA yang menghubungkan mood cuaca ke tema MaterialApp.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Hanya rebuild saat palette (mood cuaca) berubah.
    final palette =
        context.select<WeatherViewModel, WeatherPalette>((vm) => vm.palette);

    return MaterialApp(
      title: 'AWANARA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(palette),
      themeAnimationDuration: const Duration(milliseconds: 700),
      themeAnimationCurve: Curves.easeInOut,
      builder: (context, child) =>
          GradientBackground(child: child ?? const SizedBox.shrink()),
      home: const HomeScreen(),
    );
  }
}
