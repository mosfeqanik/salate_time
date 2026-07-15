import 'package:dio/dio.dart';

import 'models/prayer_timings.dart';
import 'models/selected_city.dart';
import 'prayer_times_api_client.dart';

/// User-facing wrapper around [PrayerTimesApiClient] that maps network/API
/// failures into a short, displayable message.
class PrayerTimesRepository {
  PrayerTimesRepository(this._apiClient);

  final PrayerTimesApiClient _apiClient;

  Future<PrayerTimings> getTodayTimings(SelectedCity city, {required int method}) async {
    try {
      return await _apiClient.fetchTimings(city, method: method);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw PrayerTimesFailure('Couldn\'t reach the prayer times service. Check your connection.');
      }
      throw PrayerTimesFailure('Couldn\'t load prayer times for ${city.displayLabel}.');
    } on PrayerTimesApiException {
      throw PrayerTimesFailure('Couldn\'t load prayer times for ${city.displayLabel}.');
    }
  }
}

class PrayerTimesFailure implements Exception {
  PrayerTimesFailure(this.message);
  final String message;

  @override
  String toString() => message;
}
