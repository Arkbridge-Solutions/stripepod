import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Verifies a Stripe webhook signature. To ensure the webhook is valid we
/// verify the signature and check if the timestamp is within the tolerance
/// period.
bool verifyStripeSignature({
  required String payload,
  required String stripeSignatureHeader,
  required String secret,
  int toleranceSeconds = 300, // Optional: prevent replay attacks
}) {
  // Split the header into components
  final parts = stripeSignatureHeader.split(',');
  String? timestamp;
  String? signature;

  for (final part in parts) {
    final kv = part.split('=');
    if (kv.length == 2) {
      if (kv[0] == 't') {
        timestamp = kv[1];
      } else if (kv[0] == 'v1') {
        signature = kv[1];
      }
    }
  }

  if (timestamp == null || signature == null) {
    return false;
  }

  // Create the signed payload
  final signedPayload = '$timestamp.$payload';

  // HMAC SHA256 with the webhook secret
  final hmac = Hmac(sha256, utf8.encode(secret));
  final digest = hmac.convert(utf8.encode(signedPayload));

  final expectedSignature = digest.toString();

  // Optional replay attack check
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final ts = int.tryParse(timestamp);
  if (ts == null || (now - ts).abs() > toleranceSeconds) {
    return false;
  }

  return _secureCompare(signature, expectedSignature);
}

bool _secureCompare(String a, String b) {
  if (a.length != b.length) return false;
  var result = 0;
  for (var i = 0; i < a.length; i++) {
    result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return result == 0;
}
