import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../prayer_times/presentation/providers/city_provider.dart';
import '../../../prayer_times/presentation/providers/prayer_times_provider.dart';
import '../../data/models/calculation_method.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmReset(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: scheme.error),
        title: const Text('Are you absolutely sure?'),
        content: const Text(
          'This will clear your saved city, preferences, and sign you out. '
          'All data will be permanently reset to factory defaults.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: scheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, Reset All Data'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final storage = context.read<LocalStorageService>();
    final settingsProvider = context.read<SettingsProvider>();
    final cityProvider = context.read<CityProvider>();
    final prayerTimesProvider = context.read<PrayerTimesProvider>();
    final authProvider = context.read<AuthProvider>();

    await storage.clearAll();
    settingsProvider.resetToDefaults();
    cityProvider.resetToDefault();
    prayerTimesProvider.reset();
    await authProvider.logout();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.primaryContainer.withValues(
                      alpha: 0.1,
                    ),
                    child: Icon(Icons.person, color: scheme.primaryContainer),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'USER',
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.secondary,
                          ),
                        ),
                        Text(
                          auth.phoneNumber ?? 'Not signed in',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(
                      Icons.notifications_outlined,
                      color: scheme.primaryContainer,
                    ),
                    title: const Text('Adhan Alerts'),
                    subtitle: const Text(
                      'Notify when the prayer time arrives.',
                    ),
                    value: settings.notificationsEnabled,
                    onChanged: (_) =>
                        context.read<SettingsProvider>().toggleNotifications(),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: Icon(
                      Icons.volume_up_outlined,
                      color: scheme.primaryContainer,
                    ),
                    title: const Text('Audio Signals'),
                    subtitle: const Text(
                      'Enable gentle chimes and adhan recitations.',
                    ),
                    value: settings.soundEnabled,
                    onChanged: (_) =>
                        context.read<SettingsProvider>().toggleSound(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.public, color: scheme.primaryContainer),
                    title: const Text('Calculation Method'),
                    subtitle: const Text(
                      'Convention used for calculating Fajr/Isha twilight angles.',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: DropdownButtonFormField<CalculationMethod>(
                      initialValue: settings.calculationMethod,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: CalculationMethod.all
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                m.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (method) {
                        if (method == null) return;
                        context.read<SettingsProvider>().setCalculationMethod(
                          method,
                        );
                        final city = context.read<CityProvider>().selected;
                        context.read<PrayerTimesProvider>().loadTimings(
                          city,
                          method: method.id,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: scheme.error.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'These actions are destructive and cannot be undone.',
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.error,
                          side: BorderSide(
                            color: scheme.error.withValues(alpha: 0.4),
                          ),
                        ),
                        onPressed: () => _confirmReset(context),
                        icon: const Icon(Icons.restart_alt, size: 18),
                        label: const Text('Uns App Data'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.read<AuthProvider>().logout(),
                        icon: const Icon(
                          Icons.logout,
                          size: 18,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Logout and Unsubscribe',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
