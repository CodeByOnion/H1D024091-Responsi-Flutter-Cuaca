// lib/views/search/widgets/favorites_section.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../../data/models/location_model.dart';
import 'location_tile.dart';

/// Bagian daftar lokasi favorit yang tersimpan di penyimpanan lokal.
class FavoritesSection extends StatelessWidget {
  final List<LocationModel> favorites;
  final bool Function(LocationModel) isFavorite;
  final ValueChanged<LocationModel> onSelect;
  final ValueChanged<LocationModel> onToggleFavorite;

  const FavoritesSection({
    super.key,
    required this.favorites,
    required this.isFavorite,
    required this.onSelect,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) return const SizedBox.shrink();

    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.star_rounded, size: 20, color: p.accent),
            const SizedBox(width: 8),
            Text('Favorit', style: textStyles.titleSection),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: p.accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${favorites.length}',
                style: textStyles.labelSmall.copyWith(
                  color: p.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < favorites.length; i++) ...[
          LocationTile(
            location: favorites[i],
            isFavorite: isFavorite(favorites[i]),
            onTap: () => onSelect(favorites[i]),
            onToggleFavorite: () => onToggleFavorite(favorites[i]),
          ),
          if (i < favorites.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
