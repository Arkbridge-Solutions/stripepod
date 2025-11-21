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
    final response = await _executeRequest(
      () => _httpClient.post(
        Uri.parse('$_apiUrl/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_stripeServerKey',
        },
        body: {
          'amount': priceInCents.toString(),
          'currency': 'usd',
          'automatic_payment_methods[enabled]': 'true',
        },
      ),
    );

    return response;
  }

  Future<http.Response> getPaymentIntent(String paymentIntentId) async {
    final response = await _executeRequest(
      () => _httpClient.get(
        Uri.parse('$_apiUrl/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer $_stripeServerKey',
        },
      ),
    );
    return response;
  }

  Future<http.Response> _executeRequest(
    Future<http.Response> Function() executeRequest,
  ) async {
    try {
      final response = await executeRequest();

      if (response.statusCode == 200) {
        return response;
      } else {
        throw StripeApiException(
          message: 'Request ${response.request?.url} failed',
        );
      }
    } on Exception catch (e) {
      if (e is StripeApiException) {
        rethrow;
      } else {
        throw StripeApiException(
          message: 'Failed to execute request',
          originalException: e,
        );
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
        apiUrl: 'https://api.stripe.com',
      );
    }
  }
}
