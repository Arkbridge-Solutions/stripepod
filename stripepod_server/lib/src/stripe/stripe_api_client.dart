import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:stripepod_server/src/stripe/stripe_model.dart';

/// A client for interacting with the Stripe API.
class StripeApiClient {
  /// Creates a new instance of [StripeApiClient].
  StripeApiClient({
    required String apiUrl,
    required String stripeServerKey,
    http.Client? httpClient,
  }) : _apiUrl = apiUrl,
       _stripeServerKey = stripeServerKey,
       _httpClient = httpClient ?? http.Client();

  final String _apiUrl;
  final String _stripeServerKey;
  final http.Client _httpClient;

  Future<http.Response> createPaymentIntent(int priceInCents) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_apiUrl/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_stripeServerKey',
        },
        body: {
          'amount': priceInCents.toString(),
          'currency': 'usd',
          'automatic_payment_methods': true.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw StripeApiException(
          message: 'Failed to create payment intent',
          originalException: response,
        );
      }

      return response;
    } catch (e) {
      if (e is http.ClientException) {
        throw StripeApiException(
          message: 'Failed to execute request',
          originalException: e,
        );
      } else {
        rethrow;
      }
    }
  }
}

/// Extension to get the stripe api client
extension StripeSessionExtension on Session {
  /// Gets the stripe api client
  StripeApiClient get stripeApiClient {
    if (passwords['stripeServerKey'] == null) {
      throw StripeApiException(
        message: 'Stripe server key not found',
      );
    } else {
      return StripeApiClient(
        stripeServerKey: passwords['stripeServerKey']!,
        apiUrl: 'https://api.stripe.com/',
      );
    }
  }
}
