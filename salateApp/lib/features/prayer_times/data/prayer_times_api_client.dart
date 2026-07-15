import 'package:dio/dio.dart';

import 'models/prayer_timings.dart';
import 'models/selected_city.dart';

/// Calls the Aladhan public API (https://aladhan.com/prayer-times-api) for a
/// city's prayer timings. `method` is the Aladhan calculation-method id
/// (see `features/settings/data/models/calculation_method.dart`), set by
/// the user in Settings and defaulting to Muslim World League (3).
class PrayerTimesApiClient {
  PrayerTimesApiClient(this._dio);

  final Dio _dio;

  Future<PrayerTimings> fetchTimings(SelectedCity city, {required int method}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/v1/timingsByCity',
      queryParameters: {
        'city': city.name,
        'country': city.country,
        'method': method,
      },
    );

    final body = response.data!;
    if (body['code'] != 200) {
      throw PrayerTimesApiException('Aladhan API returned code ${body['code']}');
    }

    return PrayerTimings.fromJson(body['data'] as Map<String, dynamic>);
  }
}

class PrayerTimesApiException implements Exception {
  PrayerTimesApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
