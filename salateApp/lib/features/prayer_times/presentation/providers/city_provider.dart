import 'package:flutter/foundation.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../data/models/selected_city.dart';

/// Holds the user's selected city, persisted across restarts.
class CityProvider extends ChangeNotifier {
  CityProvider(this._storage) {
    _restore();
  }

  final LocalStorageService _storage;

  SelectedCity selected = AppConstants.defaultCity;

  Future<void> _restore() async {
    final savedId = await _storage.getSelectedCityId();
    if (savedId == null) return;
    final match = AppConstants.availableCities.where((c) => c.id == savedId);
    if (match.isEmpty) return;
    selected = match.first;
    notifyListeners();
  }

  Future<void> select(SelectedCity city) async {
    if (city.id == selected.id) return;
    selected = city;
    notifyListeners();
    await _storage.setSelectedCityId(city.id);
  }

  /// Resets in-memory state to the default city. Does not touch storage —
  /// callers doing a full app data reset should already have cleared it.
  void resetToDefault() {
    selected = AppConstants.defaultCity;
    notifyListeners();
  }
}
