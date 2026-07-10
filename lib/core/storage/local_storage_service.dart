import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over [SharedPreferences] for the small bits of local state
/// this app persists: whether the user is "logged in" (mock auth), their
/// last-selected city, and their notification/sound/calculation-method
/// preferences.
class LocalStorageService {
  static const _keyIsAuthenticated = 'is_authenticated';
  static const _keyPhoneNumber = 'phone_number';
  static const _keySelectedCityId = 'selected_city_id';
  static const _keyNotificationsEnabled = 'notifications_enabled';
  static const _keySoundEnabled = 'sound_enabled';
  static const _keyCalculationMethodId = 'calculation_method_id';

  Future<bool> getIsAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAuthenticated) ?? false;
  }

  Future<void> setAuthenticated({required String phoneNumber}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsAuthenticated, true);
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  Future<void> clearAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsAuthenticated);
    await prefs.remove(_keyPhoneNumber);
  }

  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

  Future<String?> getSelectedCityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedCityId);
  }

  Future<void> setSelectedCityId(String cityId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedCityId, cityId);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, value);
  }

  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySoundEnabled, value);
  }

  Future<int?> getCalculationMethodId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCalculationMethodId);
  }

  Future<void> setCalculationMethodId(int methodId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCalculationMethodId, methodId);
  }

  /// Wipes all locally persisted app state (auth, city, preferences) — used
  /// by Settings > "Reset App Data".
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
