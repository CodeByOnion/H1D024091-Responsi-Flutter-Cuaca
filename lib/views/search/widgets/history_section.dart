// lib/views/search/widgets/history_section.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../../data/models/location_model.dart';
import 'location_tile.dart';

/// Bagian riwayat pencarian terakhir dengan tombol hapus semua riwayat.
class HistorySection extends StatelessWidget {
  final List<LocationModel> history;
  final bool Function(LocationModel) isFavorite;
  final ValueChanged<LocationModel> onSelect;
  final ValueChanged<LocationModel> onToggleFavorite;
  final VoidCallback onClearHistory;

  const HistorySection({
    super.key,
    required this.history,
    required this.isFavorite,
    required this.onSelect,
    required this.onToggleFavorite,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_rounded, size: 20, color: p.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Riwayat', style: textStyles.titleSection),
            ),
            TextButton(
              onPressed: onClearHistory,
              child: Text(
                'Hapus',
                style: textStyles.bodyMedium.copyWith(
                  color: p.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < history.length; i++) ...[
          LocationTile(
            location: history[i],
            isFavorite: isFavorite(history[i]),
            leadingIcon: Icons.access_time_rounded,
            onTap: () => onSelect(history[i]),
            onToggleFavorite: () => onToggleFavorite(history[i]),
          ),
          if (i < history.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
