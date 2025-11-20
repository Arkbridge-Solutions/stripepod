import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stripepod_server/src/pay_endpoint.dart';
import 'package:stripepod_server/src/stripe/stripe_api_client.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Pay endpoint', (sessionBuilder, endpoints) {
    test(
      'when calling `pay` with productId then returns valid payment intent client secret',
      () async {
        final mockHttpClient = MockClient((request) async {
          return http.Response(
            jsonEncode({
              'id': 'pi_test_123456789',
              'object': 'payment_intent',
              'amount': 10000,
              'currency': 'usd',
              'status': 'requires_payment_method',
              'client_secret': 'pi_test_123456789_secret_abc123',
            }),
            200,
            request: request,
          );
        });

        final mockStripeClient = StripeApiClient(
          apiUrl: 'https://api.stripe.com',
          stripeServerKey: 'sk_test_mock_key',
          httpClient: mockHttpClient,
        );

        final payEndpoint = PayEndpoint(stripeApiClient: mockStripeClient);

        final result = await payEndpoint.pay(sessionBuilder.build(), 1);

        expect(result, 'pi_test_123456789_secret_abc123');
      },
    );
  });
}
