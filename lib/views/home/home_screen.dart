// lib/views/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/weather_palette.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../forecast/seven_day_forecast_screen.dart';
import '../hourly/hourly_forecast_screen.dart';
import '../search/search_screen.dart';
import '../shared/empty_view.dart';
import '../shared/error_view.dart';
import '../shared/loading_view.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/detail_grid.dart';
import 'widgets/local_time_chip.dart';

/// Layar utama AWANARA untuk menampilkan cuaca terkini dan ringkasan prakiraan.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondary) => const SearchScreen(),
        transitionsBuilder: (context, animation, secondary, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _openSevenDay(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SevenDayForecastScreen()),
    );
  }

  void _openHourly(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const HourlyForecastScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final location = vm.selectedLocation;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_rounded, size: 22, color: p.accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location?.name ?? 'AWANARA',
                    style: textStyles.headlineCity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (location != null && location.subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  location.subtitle,
                  style: textStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: p.accent,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Tooltip(
              message: 'Cari kota',
              child: GestureDetector(
                onTap: () => _openSearch(context),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.glassFill,
                    border: Border.all(color: p.glassBorder),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: p.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, vm)),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    switch (vm.state) {
      case ViewState.loading:
        return const LoadingView();
      case ViewState.error:
        return ErrorView(
          message: vm.errorMessage.isNotEmpty ? vm.errorMessage : 'Periksa koneksi internet kamu lalu coba lagi untuk memuat cuaca terkini.',
          onRetry: vm.refresh,
        );
      case ViewState.initial:
      case ViewState.empty:
        return EmptyView(
          icon: Icons.wb_sunny_outlined,
          title: 'Cari Kota',
          subtitle:
              'Cari kota untuk melihat cuaca terkini dan prakiraan harian.',
          actionLabel: 'Cari Lokasi',
          actionIcon: Icons.search_rounded,
          onAction: () => _openSearch(context),
        );
      case ViewState.success:
        final weather = vm.weather;
        if (weather == null) {
          return EmptyView(
            icon: Icons.wb_sunny_outlined,
            title: 'Data Tidak Tersedia',
            subtitle: 'Pilih kota untuk memuat data cuaca.',
            actionLabel: 'Cari Lokasi',
            actionIcon: Icons.search_rounded,
            onAction: () => _openSearch(context),
          );
        }

        final todayForecast = weather.daily.isNotEmpty
            ? weather.daily.first
            : null;
        final precipProb = todayForecast?.precipitationProbabilityMax ?? 0;

        return RefreshIndicator(
          color: AppColors.green,
          onRefresh: vm.refresh,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final timeChip = LocalTimeChip(
                utcOffsetSeconds: weather.utcOffsetSeconds,
                timezoneAbbreviation: weather.timezoneAbbreviation,
              );
              final heroCard = CurrentWeatherCard(
                current: weather.current,
                todayForecast: todayForecast,
                onTap: () => _openHourly(context),
              );
              final detailGrid = DetailGrid(
                current: weather.current,
                precipitationProbability: precipProb,
              );
              final forecastList = DailyForecastList(
                daily: weather.daily,
                onSeeSevenDays: () => _openSevenDay(context),
              );

              if (isWide) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                timeChip,
                                const SizedBox(height: 12),
                                heroCard,
                                const SizedBox(height: 16),
                                detailGrid,
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(child: forecastList),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                children: [
                  timeChip,
                  const SizedBox(height: 12),
                  heroCard,
                  const SizedBox(height: 20),
                  detailGrid,
                  const SizedBox(height: 20),
                  forecastList,
                ],
              );
            },
          ),
        );
    }
  }
}
