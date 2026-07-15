import 'package:flutter_test/flutter_test.dart';
import 'package:salate_time/features/auth/data/models/verify_otp_response.dart';

void main() {
  group('VerifyOtpResponse.fromJson', () {
    test('parses the S1000 success payload from the bug report', () {
      final response = VerifyOtpResponse.fromJson(const {
        'version': '1.0',
        'statusCode': 'S1000',
        'subscriptionStatus': 'REGISTERED',
        'statusDetail': 'Success',
        'subscriberId':
            'tel:sdfasdfasdfwqerqwtgfgsafgasfgasdfasdfasdfasdfasdfasf',
      });

      expect(response.statusCode, 'S1000');
      expect(response.isSuccess, isTrue);
      expect(response.subscriptionStatus, 'REGISTERED');
      expect(response.statusDetail, 'Success');
      expect(response.version, '1.0');
      expect(response.subscriberId, startsWith('tel:'));
      expect(response.persistedPhoneNumber, isNot(startsWith('tel:')));
      expect(response.persistedPhoneNumber,
          'sdfasdfasdfwqerqwtgfgsafgasfgasdfasdfasdfasdfasdfasf');
    });

    test('reports isSuccess=false on E* status codes', () {
      final response = VerifyOtpResponse.fromJson(const {
        'version': '1.0',
        'statusCode': 'E1999',
        'statusDetail': 'Invalid or expired code.',
        'subscriberId': 'tel:8801676667735',
      });

      expect(response.statusCode, 'E1999');
      expect(response.isSuccess, isFalse);
      expect(response.statusDetail, 'Invalid or expired code.');
      expect(response.persistedPhoneNumber, '8801676667735');
    });

    test('returns null persistedPhoneNumber when subscriberId is missing', () {
      final response = VerifyOtpResponse.fromJson(const {
        'statusCode': 'E1999',
        'statusDetail': 'Invalid code.',
      });

      expect(response.isSuccess, isFalse);
      expect(response.subscriberId, isNull);
      expect(response.persistedPhoneNumber, isNull);
    });

    test('persistedPhoneNumber returns the raw id when no tel: prefix', () {
      final response = VerifyOtpResponse.fromJson(const {
        'subscriberId': '8801676667735',
      });
      expect(response.persistedPhoneNumber, '8801676667735');
    });
  });
}