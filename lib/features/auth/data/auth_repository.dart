import '../../../core/storage/local_storage_service.dart';

/// Mock authentication: "sending an OTP" is simulated with a delay and
/// always succeeds for a plausible phone number. No real SMS/backend for v1
/// — see docs/architecture.md for what a real implementation would replace
/// here. Auth status is persisted locally so the user stays logged in.
class AuthRepository {
  AuthRepository(this._storage);

  final LocalStorageService _storage;

  Future<void> sendOtpAndAuthenticate(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    await _storage.setAuthenticated(phoneNumber: phoneNumber);
  }

  Future<bool> isAuthenticated() => _storage.getIsAuthenticated();

  Future<String?> getPhoneNumber() => _storage.getPhoneNumber();

  Future<void> logout() => _storage.clearAuthenticated();
}
