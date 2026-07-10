import 'package:dio/dio.dart';

import '../../../core/storage/local_storage_service.dart';
import 'auth_api_client.dart';
import 'models/send_otp_response.dart';
import 'models/verify_otp_response.dart';

/// Real OTP auth: sending a code and verifying it are two separate network
/// calls against [AuthApiClient]. Auth status is only persisted once
/// `verifyOtp` actually succeeds — sending an OTP is not authentication.
class AuthRepository {
  AuthRepository(this._storage, this._apiClient);

  final LocalStorageService _storage;
  final AuthApiClient _apiClient;

  /// Returns a typed [SendOtpResult] carrying the parsed server response in
  /// both the success and failure branches. Throws [AuthFailure] only for
  /// transport-level failures (no server body to surface).
  Future<SendOtpResult> sendOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.sendOtp(phoneNumber);
      if (response.success) {
        return SendOtpSuccess(
          phoneNumber: phoneNumber,
          response: response,
          referenceNo: response.referenceNo,
        );
      }
      return SendOtpFailure(phoneNumber: phoneNumber, response: response);
    } on DioException catch (e) {
      throw AuthFailure(_messageForDioException(e));
    }
  }

  /// Returns a typed [VerifyOtpResult]. On success (`statusCode == "S1000"`)
  /// the repository also persists auth state via [LocalStorageService];
  /// the failure branch never persists. Throws [AuthFailure] only for
  /// transport-level failures.
  Future<VerifyOtpResult> verifyOtp({
    required String referenceNo,
    required String code,
  }) async {
    try {
      final response = await _apiClient.verifyOtp(
        referenceNo: referenceNo,
        code: code,
      );
      if (response.isSuccess) {
        final phone = response.persistedPhoneNumber;
        if (phone != null) {
          await _storage.setAuthenticated(phoneNumber: phone);
        }
        return VerifyOtpSuccess(
          referenceNo: referenceNo,
          code: code,
          response: response,
        );
      }
      return VerifyOtpFailure(
        referenceNo: referenceNo,
        code: code,
        response: response,
      );
    } on DioException catch (e) {
      throw AuthFailure(_messageForDioException(e));
    }
  }

  String _messageForDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Couldn\'t reach the server. Check your connection.';
    }
    return 'Something went wrong. Please try again.';
  }

  Future<bool> isAuthenticated() => _storage.getIsAuthenticated();

  Future<String?> getPhoneNumber() => _storage.getPhoneNumber();

  Future<void> logout() => _storage.clearAuthenticated();
}

class AuthFailure implements Exception {
  AuthFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Result of a `sendOtp` call against [AuthRepository]. Carries the parsed
/// server response in both branches so callers can read `statusCode`,
/// `statusDetail`, `subscriberId`, etc. without losing them when the
/// server reports `success: false`.
sealed class SendOtpResult {
  const SendOtpResult({required this.phoneNumber, required this.response});

  final String phoneNumber;

  /// Server's typed response — fields are populated regardless of branch.
  final SendOtpResponse response;

  bool get isSuccess => this is SendOtpSuccess;
}

/// Server returned `success: true` for the OTP request.
class SendOtpSuccess extends SendOtpResult {
  const SendOtpSuccess({
    required super.phoneNumber,
    required super.response,
    required this.referenceNo,
  });

  /// Server-issued reference number the user must echo back when verifying
  /// the OTP. Null only if the server omitted it on a `success: true` reply.
  final String? referenceNo;
}

/// Server returned `success: false` (e.g. `E1853` "Maximum OTP requests").
/// The [response] still carries `statusCode`/`statusDetail`/`subscriberId`.
class SendOtpFailure extends SendOtpResult {
  const SendOtpFailure({
    required super.phoneNumber,
    required super.response,
  });
}

/// Result of a `verifyOtp` call against [AuthRepository]. Carries the parsed
/// server response in both branches so callers can read `statusCode`,
/// `statusDetail`, `subscriberId`, etc. without losing them on the failure
/// branch.
sealed class VerifyOtpResult {
  const VerifyOtpResult({
    required this.referenceNo,
    required this.code,
    required this.response,
  });

  /// The reference number that was sent with the verify request.
  final String referenceNo;

  /// The user-entered OTP that was sent with the verify request.
  final String code;

  /// Server's typed response — fields are populated regardless of branch.
  final VerifyOtpResponse response;

  bool get isSuccess => this is VerifyOtpSuccess;
}

/// Server returned `statusCode == "S1000"`. The repository already
/// persisted auth state for this branch.
class VerifyOtpSuccess extends VerifyOtpResult {
  const VerifyOtpSuccess({
    required super.referenceNo,
    required super.code,
    required super.response,
  });
}

/// Server returned a non-S1000 status code (e.g. `E1999`). No state was
/// persisted; the caller should surface `response.statusDetail` to the UI.
class VerifyOtpFailure extends VerifyOtpResult {
  const VerifyOtpFailure({
    required super.referenceNo,
    required super.code,
    required super.response,
  });
}
