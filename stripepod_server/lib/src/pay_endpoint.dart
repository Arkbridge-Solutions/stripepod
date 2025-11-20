import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:stripepod_server/src/product_endpoint.dart';
import 'package:stripepod_server/src/stripe/stripe_api_client.dart';

/// Endpoint that will create a payment intent and return the payment intent
/// client secret
class PayEndpoint extends Endpoint {
  /// Optional stripe client for testing purposes
  PayEndpoint({StripeApiClient? stripeApiClient})
    : _stripeApiClient = stripeApiClient;

  final StripeApiClient? _stripeApiClient;

  Future<String> pay(Session session, int productId) async {
    // Use injected client for testing, otherwise get from session
    final stripeApiClient = _stripeApiClient ?? session.stripeApiClient;

    try {
      final product = await ProductEndpoint().getProduct(session, productId);

      final response = await stripeApiClient.createPaymentIntent(
        product.priceInCents,
      );
      final json = jsonDecode(response.body);

      if (json['client_secret'] != null) {
        return json['client_secret']!;
      } else {
        throw ApiException(500, 'Failed to create payment intent');
      }
    } on Exception catch (e) {
      throw ApiException(500, e.toString());
    }
  }
}

class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiException &&
        other.statusCode == statusCode &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(statusCode, message);
}
