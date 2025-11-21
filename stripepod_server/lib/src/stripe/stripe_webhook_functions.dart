import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:stripepod_server/src/generated/protocol.dart';
import 'package:stripepod_server/src/stripe/stripe_api_client.dart';
import 'package:stripepod_server/src/stripe/stripe_model.dart';

// When a webhook comes in we cannot rely on its payload. Stripe always
// recommends checking the data through the api.
Future<void> checkPaymentIntentAndUpdateStatus({
  required Session session,
  required String paymentIntentId,
  required StripeApiClient stripeApiClient,
}) async {
  try {
    final response = await stripeApiClient.getPaymentIntent(paymentIntentId);
    final json = jsonDecode(response.body);
    final status = (json['status'] as String).toPaymentStatus();
    final payment = await Payment.db.findFirstRow(
      session,
      where: (table) => table.stripeId.equals(paymentIntentId),
    );
    if (payment == null) {
      throw StripeApiException(message: 'Payment not found');
    }
    await Payment.db.updateRow(session, payment.copyWith(status: status));
  } on Exception catch (e) {
    if (e is StripeApiException) {
      rethrow;
    }
    throw StripeApiException(message: 'Failed to update payment $e');
  }
}

extension PaymentStatusX on String? {
  PaymentStatus toPaymentStatus() {
    switch (this) {
      case 'succeeded':
        return PaymentStatus.succeeded;
      case 'processing':
        return PaymentStatus.pending;
      case 'canceled':
        return PaymentStatus.canceled;
      case 'failed':
      case 'requires_action':
      case 'requires_confirmation':
      case 'requires_capture':
      case 'requires_payment_method':
        return PaymentStatus.failed;
      default:
        throw Exception(
          'Value "$this" cannot be converted to "PaymentStatus"',
        );
    }
  }
}
