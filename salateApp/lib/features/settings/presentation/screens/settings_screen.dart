import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../prayer_times/presentation/providers/city_provider.dart';
import '../../../prayer_times/presentation/providers/prayer_times_provider.dart';
import '../../../prayer_times/presentation/widgets/city_switcher_sheet.dart';
import '../providers/settings_provider.dart';
import '../widgets/calculation_method_sheet.dart';

/// SalatTime's tagline, shown in the About section.
const _appDescription =
    'SalatTime is a calm companion for your daily prayers — accurate '
    'prayer times for your chosen city, a clean schedule for the day '
    'ahead, and gentle reminders so you never miss a moment of '
    'reflection.';

const _appVersion = '1.0.0';

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
    final city = context.watch<CityProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            // Profile
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

            const _SectionLabel('PREFERENCES'),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Prayer City',
                  subtitle: city.selected.displayLabel,
                  onTap: () => showCitySwitcherSheet(
                    context: context,
                    selected: city.selected,
                    onSelect: (selected) => city.select(selected),
                  ),
                ),
                const _TileDivider(),
                _SettingsTile(
                  icon: Icons.calculate_outlined,
                  title: 'Calculation Method',
                  subtitle: settings.calculationMethod.label,
                  onTap: () => showCalculationMethodSheet(
                    context: context,
                    selected: settings.calculationMethod,
                    onSelect: (method) => settings.setCalculationMethod(method),
                  ),
                ),
                const _TileDivider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: Icon(
                    Icons.notifications_outlined,
                    color: scheme.primaryContainer,
                  ),
                  title: const Text('Notifications'),
                  subtitle: const Text('Get notified at prayer times'),
                  value: settings.notificationsEnabled,
                  onChanged: (_) => settings.toggleNotifications(),
                ),
                const _TileDivider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: Icon(
                    Icons.volume_up_outlined,
                    color: scheme.primaryContainer,
                  ),
                  title: const Text('Adhan Sound'),
                  subtitle: const Text('Play a sound with notifications'),
                  value: settings.soundEnabled,
                  onChanged: settings.notificationsEnabled
                      ? (_) => settings.toggleSound()
                      : null,
                ),
              ],
            ),

            const _SectionLabel('ABOUT'),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: scheme.primaryContainer,
                        child: Icon(
                          Icons.explore,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SalatTime',
                        style: textTheme.headlineMedium?.copyWith(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        'v$_appVersion',
                        style: textTheme.labelSmall?.copyWith(
                          color: scheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _appDescription,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const _SectionLabel('DANGER ZONE'),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: scheme.error.withValues(alpha: 0.3)),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _confirmReset(context),
                    icon: Icon(
                      Icons.restart_alt,
                      size: 18,
                      color: scheme.error,
                    ),
                    label: Text(
                      'Reset All Data',
                      style: TextStyle(color: scheme.error),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.read<AuthProvider>().logout(),
                    icon: Icon(Icons.logout, size: 18, color: scheme.error),
                    label: Text(
                      'Logout and Unsubscribe',
                      style: TextStyle(color: scheme.error),
                    ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.base,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.secondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(children: children),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: scheme.primaryContainer),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: scheme.outline),
      onTap: onTap,
    );
  }
}
