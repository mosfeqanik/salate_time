import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../prayer_schedule_calculator.dart';

/// The large "current prayer" card at the top of Home: current prayer name,
/// countdown to the next one, and a progress bar showing how far through the
/// current window we are.
class PrayerHeroCard extends StatelessWidget {
  const PrayerHeroCard({super.key, required this.status});

  final PrayerScheduleStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT PRAYER',
            style: textTheme.labelSmall?.copyWith(color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 8),
          Text(
            status.currentName,
            style: textTheme.displayLarge?.copyWith(color: scheme.onPrimary, fontSize: 40),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: textTheme.bodyLarge?.copyWith(color: scheme.onPrimaryContainer),
              children: [
                const TextSpan(text: 'Ends in '),
                TextSpan(
                  text: status.remainingLabel,
                  style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Time remaining', style: textTheme.labelSmall?.copyWith(color: scheme.onPrimaryContainer)),
              Text(
                '${(status.percentElapsed * 100).round()}% complete',
                style: textTheme.labelSmall?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: status.percentElapsed,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(scheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: AppRadius.fullRadius,
              ),
              child: Text(
                'Next: ${status.nextName}',
                style: textTheme.labelSmall?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
