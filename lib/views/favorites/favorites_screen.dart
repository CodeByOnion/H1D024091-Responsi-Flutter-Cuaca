// lib/views/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/weather_palette.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../../viewmodels/location_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../shared/empty_view.dart';
import '../shared/glass_card.dart';

/// Halaman daftar kota favorit beserta cuaca terkini masing-masing.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesViewModel _vm;

  @override
  void initState() {
    super.initState();
    // Ambil repository dari Provider root agar tidak ada duplikasi instance.
    final repo = Provider.of<WeatherRepository>(context, listen: false);
    _vm = FavoritesViewModel(repo);
    _vm.loadFavorites();
  }

  void _selectCity(LocationModel location) {
    context.read<WeatherViewModel>().loadWeather(location);
    // Navigasi kembali ke Home (pop semua sampai root).
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoritesViewModel>.value(
      value: _vm,
      child: const _FavoritesBody(),
    );
  }
}

class _FavoritesBody extends StatelessWidget {
  const _FavoritesBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoritesViewModel>();
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);
    final locationVm = context.read<LocationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit', style: textStyles.titleSection),
        actions: [
          if (vm.items.isNotEmpty)
            IconButton(
              onPressed: vm.refresh,
              tooltip: 'Muat ulang cuaca',
              icon: Icon(Icons.refresh_rounded, color: p.textPrimary),
            ),
        ],
      ),
      body: SafeArea(
        child: vm.items.isEmpty
            ? const EmptyView(
                icon: Icons.star_border_rounded,
                title: 'Belum ada kota favorit',
                subtitle: 'Tambahkan kota favorit melalui halaman pencarian dengan menekan ikon bintang.',
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: vm.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final item = vm.items[i];
                  return _FavoriteCard(
                    item: item,
                    onTap: () {
                      context
                          .findAncestorStateOfType<_FavoritesScreenState>()
                          ?._selectCity(item.location);
                    },
                    onRemove: () async {
                      await vm.removeFavorite(item.location);
                      await locationVm.loadSavedData();
                    },
                    onRetry: () => vm.retryItem(item.location),
                  );
                },
              ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteItemState item;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  const _FavoriteCard({
    required this.item,
    required this.onTap,
    required this.onRemove,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return GlassCard(
      radius: 22,
      blur: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: item.state == ViewState.success ? onTap : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: p.accent.withValues(alpha: 0.14),
            ),
            child: Icon(Icons.location_on_rounded, color: p.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.location.name,
                  style: textStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.location.subtitle.isNotEmpty)
                  Text(
                    item.location.subtitle,
                    style: textStyles.bodyMedium.copyWith(
                      color: p.accent,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                _WeatherStatus(item: item, onRetry: onRetry),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onRemove,
            tooltip: 'Hapus dari favorit',
            icon: Icon(Icons.star_rounded, color: p.favorite, size: 24),
          ),
        ],
      ),
    );
  }
}

class _WeatherStatus extends StatelessWidget {
  final FavoriteItemState item;
  final VoidCallback onRetry;
  const _WeatherStatus({required this.item, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    switch (item.state) {
      case ViewState.loading:
        return Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: p.accent),
            ),
            const SizedBox(width: 8),
            Text('Memuat...', style: textStyles.labelSmall),
          ],
        );
      case ViewState.error:
        return Row(
          children: [
            Icon(Icons.error_outline_rounded, size: 14, color: p.error),
            const SizedBox(width: 6),
            Text(
              'Gagal dimuat',
              style: textStyles.labelSmall.copyWith(color: p.error),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRetry,
              child: Text(
                'Coba lagi',
                style: textStyles.labelSmall.copyWith(
                  color: p.accent,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        );
      case ViewState.success:
        final weather = item.weather!;
        final info = mapWeatherCode(weather.current.weatherCode);
        return Row(
          children: [
            Icon(
              info.icon,
              size: 16,
              color: p.isLight ? p.accent : p.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              '${weather.current.temperature.round()}°C  •  ${info.label}',
              style: textStyles.bodyMedium,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
