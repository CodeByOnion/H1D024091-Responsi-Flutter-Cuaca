// lib/views/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/weather_palette.dart';
import '../../data/models/location_model.dart';
import '../../viewmodels/location_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../shared/empty_view.dart';
import '../shared/error_view.dart';
import 'widgets/favorites_section.dart';
import 'widgets/history_section.dart';
import 'widgets/location_tile.dart';
import 'widgets/search_field.dart';

/// Layar pencarian kota, daftar favorit, dan riwayat pencarian.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {});
    context.read<LocationViewModel>().clearResults();
  }

  void _selectLocation(LocationModel location) {
    final locationVm = context.read<LocationViewModel>();
    final weatherVm = context.read<WeatherViewModel>();

    locationVm.addToHistory(location);
    locationVm.clearResults();
    weatherVm.loadWeather(location);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locationVm = context.watch<LocationViewModel>();
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final hasQuery = _controller.text.trim().length >= 2;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cari Lokasi', style: textStyles.titleSection),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth =
                constraints.maxWidth >= 600 ? 560.0 : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                      child: SearchField(
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {});
                          locationVm.search(value);
                        },
                        onClear: _clearSearch,
                      ),
                    ),
                    if (locationVm.searchState == ViewState.loading)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            minHeight: 3,
                            color: p.accent,
                            backgroundColor: p.glassFillSoft,
                          ),
                        ),
                      ),
                    Expanded(
                      child: hasQuery
                          ? _buildSearchResults(locationVm, p, textStyles)
                          : _buildSavedSections(locationVm),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSavedSections(LocationViewModel locationVm) {
    final hasFavorites = locationVm.favorites.isNotEmpty;
    final hasHistory = locationVm.history.isNotEmpty;

    if (!hasFavorites && !hasHistory) {
      return const EmptyView(
        icon: Icons.travel_explore_rounded,
        title: 'Mulai Mencari Kota',
        subtitle:
            'Ketik minimal 2 huruf nama kota untuk melihat cuaca atau simpan ke favorit.',
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        FavoritesSection(
          favorites: locationVm.favorites,
          isFavorite: locationVm.isFavorite,
          onSelect: _selectLocation,
          onToggleFavorite: locationVm.toggleFavorite,
        ),
        if (hasFavorites && hasHistory) const SizedBox(height: 24),
        HistorySection(
          history: locationVm.history,
          isFavorite: locationVm.isFavorite,
          onSelect: _selectLocation,
          onToggleFavorite: locationVm.toggleFavorite,
          onClearHistory: locationVm.clearHistory,
        ),
      ],
    );
  }

  Widget _buildSearchResults(
    LocationViewModel locationVm,
    WeatherPalette p,
    AppTextStyles textStyles,
  ) {
    switch (locationVm.searchState) {
      case ViewState.loading:
      case ViewState.initial:
        return const SizedBox.shrink();
      case ViewState.empty:
        return EmptyView(
          icon: Icons.search_off_rounded,
          title: 'Kota tidak ditemukan',
          subtitle: 'Coba periksa ejaan atau cari nama kota lain di sekitarmu.',
          actionLabel: 'Hapus Kata Kunci',
          actionIcon: Icons.refresh_rounded,
          onAction: _clearSearch,
        );
      case ViewState.error:
        return ErrorView(
          message: locationVm.errorMessage.isNotEmpty
              ? locationVm.errorMessage
              : 'Periksa koneksi internet kamu lalu coba lagi.',
          onRetry: locationVm.retrySearch,
        );
      case ViewState.success:
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: locationVm.results.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                children: [
                  Text('Hasil Pencarian', style: textStyles.titleSection),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: p.accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${locationVm.results.length} ditemukan',
                      style: textStyles.labelSmall.copyWith(
                        color: p.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text('Pilih lokasi', style: textStyles.labelSmall),
                ],
              );
            }
            final loc = locationVm.results[index - 1];
            return LocationTile(
              location: loc,
              isFavorite: locationVm.isFavorite(loc),
              onTap: () => _selectLocation(loc),
              onToggleFavorite: () => locationVm.toggleFavorite(loc),
            );
          },
        );
    }
  }
}
