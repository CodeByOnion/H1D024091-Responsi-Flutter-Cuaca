// lib/views/search/widgets/location_tile.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../../data/models/location_model.dart';
import '../../shared/glass_card.dart';

/// Tile lokasi yang dipakai ulang untuk hasil pencarian, daftar favorit, dan riwayat.
class LocationTile extends StatelessWidget {
  final LocationModel location;
  final bool isFavorite;
  final IconData leadingIcon;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const LocationTile({
    super.key,
    required this.location,
    required this.isFavorite,
    this.leadingIcon = Icons.location_on_rounded,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return GlassCard(
      radius: 22,
      blur: 10,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.accent.withValues(alpha: 0.14),
              ),
              child: Icon(
                leadingIcon,
                color: p.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    location.name,
                    style: textStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location.subtitle.isNotEmpty)
                    Text(
                      location.subtitle,
                      style: textStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: p.accent,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: onToggleFavorite,
              tooltip: isFavorite ? 'Hapus dari favorit' : 'Simpan ke favorit',
              icon: AnimatedScale(
                scale: isFavorite ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isFavorite ? p.favorite : p.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
