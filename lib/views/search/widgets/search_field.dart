// lib/views/search/widgets/search_field.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/weather_palette.dart';
import '../../shared/glass_card.dart';

/// Input pencarian kota bergaya glass pill dengan tombol hapus teks.
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return GlassCard(
      radius: 999,
      blur: 10,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: textStyles.bodyLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Cari kota...',
          hintStyle: textStyles.bodyLarge.copyWith(color: p.textMuted),
          prefixIcon: Icon(Icons.search_rounded, color: p.accent),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  tooltip: 'Hapus pencarian',
                  icon: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.accent.withValues(alpha: 0.14),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: p.textPrimary,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
