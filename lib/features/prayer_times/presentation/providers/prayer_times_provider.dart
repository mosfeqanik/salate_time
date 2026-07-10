import 'package:flutter/foundation.dart';

import '../../data/models/prayer_timings.dart';
import '../../data/models/selected_city.dart';
import '../../data/prayer_times_repository.dart';

enum PrayerTimesState { initial, loading, loaded, error }

class PrayerTimesProvider extends ChangeNotifier {
  PrayerTimesProvider(this._repository);

  final PrayerTimesRepository _repository;

  PrayerTimesState state = PrayerTimesState.initial;
  PrayerTimings? timings;
  String? errorMessage;

  Future<void> loadTimings(SelectedCity city, {required int method}) async {
    state = PrayerTimesState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      timings = await _repository.getTodayTimings(city, method: method);
      state = PrayerTimesState.loaded;
    } catch (e) {
      errorMessage = e.toString();
      state = PrayerTimesState.error;
    }
    notifyListeners();
  }

  void reset() {
    state = PrayerTimesState.initial;
    timings = null;
    errorMessage = null;
    notifyListeners();
  }
}
