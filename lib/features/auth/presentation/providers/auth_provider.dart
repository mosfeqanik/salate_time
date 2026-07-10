import 'package:flutter/foundation.dart';

import '../../data/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Holds auth state for the whole app. `status` starts as [AuthStatus.unknown]
/// while the persisted flag is being restored; the router's redirect logic
/// waits on that before deciding where to send the user.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository) {
    _restore();
  }

  final AuthRepository _repository;

  AuthStatus status = AuthStatus.unknown;
  String? phoneNumber;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> _restore() async {
    final authenticated = await _repository.isAuthenticated();
    phoneNumber = await _repository.getPhoneNumber();
    status = authenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> sendOtp(String phoneNumber) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendOtpAndAuthenticate(phoneNumber);
      this.phoneNumber = phoneNumber;
      status = AuthStatus.authenticated;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    phoneNumber = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
