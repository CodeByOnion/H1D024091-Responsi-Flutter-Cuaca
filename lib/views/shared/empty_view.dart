// lib/views/shared/empty_view.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/weather_palette.dart';
import 'glass_card.dart';

/// Tampilan state kosong mengikuti desain Kota Tidak Ditemukan.png.
class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;

  const EmptyView({
    super.key,
    this.icon = Icons.search_off_rounded,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.actionIcon = Icons.refresh_rounded,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).extension<WeatherPalette>()!;
    final textStyles = AppTextStyles.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: GlassCard(
            radius: 28,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.accent.withValues(alpha: 0.14),
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: p.accent,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: textStyles.titleCondition
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: textStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAction,
                      icon: Icon(actionIcon, size: 18),
                      label: Text(actionLabel!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
