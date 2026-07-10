import 'package:flutter/material.dart';

import '../../data/models/prayer_timings.dart';
import 'prayer_card.dart';

/// Responsive 1/2/5-column grid of the day's five prayers, matching the
/// reference design's breakpoints.
class PrayerGrid extends StatelessWidget {
  const PrayerGrid({super.key, required this.timings, required this.currentName});

  final PrayerTimings timings;
  final String currentName;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900 ? 5 : (width >= 600 ? 2 : 1);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: columns == 1 ? 2.6 : 0.85,
      children: timings.schedule
          .map(
            (entry) => PrayerCard(
              name: entry.key,
              time: entry.value,
              isActive: entry.key == currentName,
              sunrise: entry.key == 'Fajr' ? timings.sunrise : null,
            ),
          )
          .toList(),
    );
  }
}
