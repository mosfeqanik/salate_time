import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../data/models/selected_city.dart';
import '../prayer_schedule_calculator.dart';
import '../providers/city_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../widgets/city_switcher_sheet.dart';
import '../widgets/prayer_grid.dart';
import '../widgets/prayer_hero_card.dart';

/// The Home tab: today's prayer schedule for the selected city, fetched live
/// from the Aladhan API.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final city = context.read<CityProvider>().selected;
      final method = context.read<SettingsProvider>().calculationMethod.id;
      context.read<PrayerTimesProvider>().loadTimings(city, method: method);
    });
  }

  void _onCitySelected(SelectedCity city) {
    context.read<CityProvider>().select(city);
    final method = context.read<SettingsProvider>().calculationMethod.id;
    context.read<PrayerTimesProvider>().loadTimings(city, method: method);
  }

  @override
  Widget build(BuildContext context) {
    final city = context.watch<CityProvider>().selected;
    final prayerTimes = context.watch<PrayerTimesProvider>();
    final methodId = context.watch<SettingsProvider>().calculationMethod.id;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => showCitySwitcherSheet(
            context: context,
            selected: city,
            onSelect: _onCitySelected,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: scheme.primaryContainer, size: 20),
              const SizedBox(width: 4),
              Text(city.displayLabel, style: textTheme.labelLarge),
              const Icon(Icons.expand_more, size: 18),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => prayerTimes.loadTimings(city, method: methodId),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            children: [
              Builder(
                builder: (context) {
                  switch (prayerTimes.state) {
                    case PrayerTimesState.initial:
                    case PrayerTimesState.loading:
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    case PrayerTimesState.error:
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          children: [
                            Icon(Icons.cloud_off, color: scheme.error, size: 40),
                            const SizedBox(height: 12),
                            Text(
                              prayerTimes.errorMessage ?? 'Something went wrong.',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () => prayerTimes.loadTimings(city, method: methodId),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    case PrayerTimesState.loaded:
                      final timings = prayerTimes.timings!;
                      final status = PrayerScheduleCalculator(timings).statusAt(DateTime.now());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrayerHeroCard(status: status),
                          const SizedBox(height: AppSpacing.md),
                          Text('Daily Prayers', style: textTheme.headlineMedium),
                          const SizedBox(height: AppSpacing.sm),
                          PrayerGrid(timings: timings, currentName: status.currentName),
                        ],
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
