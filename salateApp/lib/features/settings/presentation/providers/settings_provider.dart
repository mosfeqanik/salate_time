import 'package:flutter/foundation.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../data/models/calculation_method.dart';

/// Notification/sound preferences and the prayer-time calculation method,
/// persisted locally. Toggling notifications/sound only stores the
/// preference for now — no local notifications or adhan audio are actually
/// wired up yet (see docs/architecture.md). The calculation method *is*
/// fully wired: it's the `method` param sent to the Aladhan API.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._storage) {
    _restore();
  }

  final LocalStorageService _storage;

  bool notificationsEnabled = true;
  bool soundEnabled = true;
  CalculationMethod calculationMethod = CalculationMethod.defaultMethod;

  Future<void> _restore() async {
    notificationsEnabled = await _storage.getNotificationsEnabled();
    soundEnabled = await _storage.getSoundEnabled();
    final savedMethodId = await _storage.getCalculationMethodId();
    if (savedMethodId != null) {
      calculationMethod = CalculationMethod.fromId(savedMethodId);
    }
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    notificationsEnabled = !notificationsEnabled;
    notifyListeners();
    await _storage.setNotificationsEnabled(notificationsEnabled);
  }

  Future<void> toggleSound() async {
    soundEnabled = !soundEnabled;
    notifyListeners();
    await _storage.setSoundEnabled(soundEnabled);
  }

  Future<void> setCalculationMethod(CalculationMethod method) async {
    if (method.id == calculationMethod.id) return;
    calculationMethod = method;
    notifyListeners();
    await _storage.setCalculationMethodId(method.id);
  }

  /// Resets in-memory state to defaults. Does not touch storage — callers
  /// doing a full app data reset should already have cleared it.
  void resetToDefaults() {
    notificationsEnabled = true;
    soundEnabled = true;
    calculationMethod = CalculationMethod.defaultMethod;
    notifyListeners();
  }
}
