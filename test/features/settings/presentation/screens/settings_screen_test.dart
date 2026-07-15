import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salate_time/core/storage/local_storage_service.dart';
import 'package:salate_time/core/theme/app_theme.dart';
import 'package:salate_time/features/auth/data/auth_api_client.dart';
import 'package:salate_time/features/auth/data/auth_repository.dart';
import 'package:salate_time/features/auth/presentation/providers/auth_provider.dart';
import 'package:salate_time/features/prayer_times/data/prayer_times_api_client.dart';
import 'package:salate_time/features/prayer_times/data/prayer_times_repository.dart';
import 'package:salate_time/features/prayer_times/presentation/providers/city_provider.dart';
import 'package:salate_time/features/prayer_times/presentation/providers/prayer_times_provider.dart';
import 'package:salate_time/features/settings/presentation/providers/settings_provider.dart';
import 'package:salate_time/features/settings/presentation/screens/settings_screen.dart';

void main() {
  Future<void> pumpSettingsScreen(WidgetTester tester) async {
    // Tall surface so every section (down to Danger Zone) is mounted by the
    // ListView's sliver without needing to scroll to bring it into the
    // cache extent.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LocalStorageService>.value(value: storage),
          ChangeNotifierProvider(
            create: (_) =>
                AuthProvider(AuthRepository(storage, AuthApiClient(Dio()))),
          ),
          ChangeNotifierProvider(create: (_) => CityProvider(storage)),
          ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
          ChangeNotifierProvider(
            create: (_) => PrayerTimesProvider(
              PrayerTimesRepository(PrayerTimesApiClient(Dio())),
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows profile, preferences, about, and danger zone sections', (
    tester,
  ) async {
    await pumpSettingsScreen(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Not signed in'), findsOneWidget);

    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('Prayer City'), findsOneWidget);
    expect(find.text('Calculation Method'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Adhan Sound'), findsOneWidget);

    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('SalatTime'), findsOneWidget);
    expect(find.textContaining('calm companion'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);

    expect(find.text('DANGER ZONE'), findsOneWidget);
    expect(find.text('Reset All Data'), findsOneWidget);
    expect(find.text('Logout and Unsubscribe'), findsOneWidget);
  });

  testWidgets('tapping Reset All Data shows the confirmation dialog', (
    tester,
  ) async {
    await pumpSettingsScreen(tester);

    await tester.tap(find.text('Reset All Data'));
    await tester.pumpAndSettle();

    expect(find.text('Are you absolutely sure?'), findsOneWidget);
    expect(find.text('Yes, Reset All Data'), findsOneWidget);
  });
}
