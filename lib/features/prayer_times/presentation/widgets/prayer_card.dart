import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';

const _prayerIcons = {
  'Fajr': Icons.wb_twilight,
  'Dhuhr': Icons.wb_sunny,
  'Asr': Icons.light_mode,
  'Maghrib': Icons.wb_twilight,
  'Isha': Icons.bedtime,
};

/// A single prayer's card in the daily grid. [sunrise] is only shown under
/// Fajr, matching the reference design.
class PrayerCard extends StatelessWidget {
  const PrayerCard({
    super.key,
    required this.name,
    required this.time,
    required this.isActive,
    this.sunrise,
  });

  final String name;
  final String time;
  final bool isActive;
  final String? sunrise;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: isActive ? scheme.primaryContainer.withValues(alpha: 0.06) : scheme.surfaceContainerLowest,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isActive ? scheme.primaryContainer.withValues(alpha: 0.3) : scheme.outlineVariant.withValues(alpha: 0.3),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _prayerIcons[name] ?? Icons.access_time,
            color: isActive ? scheme.primaryContainer : scheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            name.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: isActive ? scheme.primaryContainer : scheme.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: textTheme.headlineMedium?.copyWith(fontSize: 20)),
          if (sunrise != null) ...[
            const SizedBox(height: 6),
            Text('Sunrise $sunrise', style: textTheme.labelSmall?.copyWith(color: scheme.outline)),
          ],
          if (isActive) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: AppRadius.fullRadius,
              ),
              child: Text(
                'ACTIVE',
                style: textTheme.labelSmall?.copyWith(color: scheme.onPrimary, fontSize: 9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
