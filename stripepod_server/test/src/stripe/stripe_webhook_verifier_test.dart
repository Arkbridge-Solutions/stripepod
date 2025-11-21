import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:stripepod_server/src/stripe/stripe_webhook_verifier.dart';
import 'package:test/test.dart';

void main() {
  group('Stripe Webhook Verifier', () {
    const testSecret = 'whsec_test_secret_key';
    const testPayload =
        '{"id":"evt_test123","type":"payment_intent.succeeded"}';

    String generateValidSignature(
      String payload,
      String secret,
      int timestamp,
    ) {
      final signedPayload = '$timestamp.$payload';
      final hmac = Hmac(sha256, utf8.encode(secret));
      final digest = hmac.convert(utf8.encode(signedPayload));
      return 't=$timestamp,v1=$digest';
    }

    test('verifyStripeSignature returns true for valid signature', () {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final validSignature = generateValidSignature(
        testPayload,
        testSecret,
        timestamp,
      );

      final result = verifyStripeSignature(
        payload: testPayload,
        stripeSignatureHeader: validSignature,
        secret: testSecret,
      );

      expect(result, isTrue);
    });

    test('verifyStripeSignature returns false for invalid signature', () {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final validSignature = generateValidSignature(
        testPayload,
        testSecret,
        timestamp,
      );
      final invalidSignature = validSignature.replaceAll('v1=', 'v1=invalid');

      final result = verifyStripeSignature(
        payload: testPayload,
        stripeSignatureHeader: invalidSignature,
        secret: testSecret,
      );

      expect(result, isFalse);
    });

    test('verifyStripeSignature returns false for tampered payload', () {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final validSignature = generateValidSignature(
        testPayload,
        testSecret,
        timestamp,
      );
      final tamperedPayload = testPayload.replaceAll(
        'evt_test123',
        'evt_tampered',
      );

      final result = verifyStripeSignature(
        payload: tamperedPayload,
        stripeSignatureHeader: validSignature,
        secret: testSecret,
      );

      expect(result, isFalse);
    });

    test(
      'verifyStripeSignature returns false for malformed signature header',
      () {
        final result = verifyStripeSignature(
          payload: testPayload,
          stripeSignatureHeader: 'malformed_header',
          secret: testSecret,
        );

        expect(result, isFalse);
      },
    );

    test('verifyStripeSignature returns false for missing timestamp', () {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final validSignature = generateValidSignature(
        testPayload,
        testSecret,
        timestamp,
      );
      final noTimestampSignature = validSignature.replaceAll(
        't=$timestamp,',
        '',
      );

      final result = verifyStripeSignature(
        payload: testPayload,
        stripeSignatureHeader: noTimestampSignature,
        secret: testSecret,
      );

      expect(result, isFalse);
    });

    test('verifyStripeSignature returns false for missing signature', () {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // We don't need to generate a valid signature for this test
      final noSignaturePart = 't=$timestamp';

      final result = verifyStripeSignature(
        payload: testPayload,
        stripeSignatureHeader: noSignaturePart,
        secret: testSecret,
      );

      expect(result, isFalse);
    });

    test('verifyStripeSignature returns false for expired timestamp', () {
      // Create a fixed clock at the current time
      final now = DateTime(2025, 10, 25);

      // Generate a timestamp that's older than the tolerance
      final expiredTimestamp =
          (now.millisecondsSinceEpoch ~/ 1000) -
          301; // 301 seconds ago (tolerance is 300)
      final expiredSignature = generateValidSignature(
        testPayload,
        testSecret,
        expiredTimestamp,
      );

      final result = verifyStripeSignature(
        payload: testPayload,
        stripeSignatureHeader: expiredSignature,
        secret: testSecret,
      );

      expect(result, isFalse);
    });

    test('verifyStripeSignature returns false for future timestamp', () {
      // Create a fixed clock at the current time
      final now = DateTime(2045);

      // Generate a timestamp that's in the future beyond the tolerance
      final futureTimestamp =
          (now.millisecondsSinceEpoch ~/ 1000) +
          301; // 301 seconds in the future
      final futureSignature = generateValidSignature(
        testPayload,
        testSecret,
        futureTimestamp,
      );

      final result = verifyStripeSignature(
        payload: testPayload,
        stripeSignatureHeader: futureSignature,
        secret: testSecret,
      );

      expect(result, isFalse);
    });
  });
}
