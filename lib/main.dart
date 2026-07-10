import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/network/dio_client.dart';
import 'core/storage/local_storage_service.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/prayer_times/data/prayer_times_api_client.dart';
import 'features/prayer_times/data/prayer_times_repository.dart';
import 'features/prayer_times/presentation/providers/city_provider.dart';
import 'features/prayer_times/presentation/providers/prayer_times_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

void main() {
  final storage = LocalStorageService();
  final Dio dio = DioClient.create(baseUrl: 'https://api.aladhan.com');

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: storage),
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthRepository(storage))),
        ChangeNotifierProvider(create: (_) => CityProvider(storage)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
        ChangeNotifierProvider(
          create: (_) => PrayerTimesProvider(PrayerTimesRepository(PrayerTimesApiClient(dio))),
        ),
      ],
      child: const App(),
    ),
  );
}
