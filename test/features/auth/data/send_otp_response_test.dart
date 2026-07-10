import 'package:flutter_test/flutter_test.dart';
import 'package:salate_time/features/auth/data/models/send_otp_response.dart';

void main() {
  group('SendOtpResponse.fromJson', () {
    test('parses the failure payload from the bug report', () {
      final response = SendOtpResponse.fromJson(const {
        'success': false,
        'message':
            'Maximum number of OTP requests reached for [salatTime/tel:8801676667735]',
        'referenceNo': null,
        'statusCode': 'E1853',
        'statusDetail':
            'Maximum number of OTP requests reached for [salatTime/tel:8801676667735]',
        'version': '1.0',
        'subscriberId': 'tel:8801676667735',
      });

      expect(response.success, isFalse);
      expect(
        response.message,
        'Maximum number of OTP requests reached for [salatTime/tel:8801676667735]',
      );
      expect(response.referenceNo, isNull);
      expect(response.statusCode, 'E1853');
      expect(response.statusDetail, contains('Maximum number of OTP requests'));
      expect(response.version, '1.0');
      expect(response.subscriberId, 'tel:8801676667735');
    });

    test('parses a success payload with a reference number', () {
      final response = SendOtpResponse.fromJson(const {
        'success': true,
        'referenceNo': 'REF-12345',
        'version': '1.0',
        'subscriberId': 'tel:8801676667735',
      });

      expect(response.success, isTrue);
      expect(response.referenceNo, 'REF-12345');
      expect(response.message, isNull);
      expect(response.statusCode, isNull);
    });

    test('parses int 1/0 as true/false (PHP backend edge case)', () {
      final truthy = SendOtpResponse.fromJson(const {'success': 1});
      final falsy = SendOtpResponse.fromJson(const {'success': 0});
      expect(truthy.success, isTrue);
      expect(falsy.success, isFalse);
    });

    test('parses "true"/"false" string booleans', () {
      expect(
        SendOtpResponse.fromJson(const {'success': 'true'}).success,
        isTrue,
      );
      expect(
        SendOtpResponse.fromJson(const {'success': 'false'}).success,
        isFalse,
      );
    });

    test('treats missing/null success as false', () {
      expect(
        SendOtpResponse.fromJson(const <String, dynamic>{}).success,
        isFalse,
      );
      expect(
        SendOtpResponse.fromJson(const {'success': null}).success,
        isFalse,
      );
    });
  });
}