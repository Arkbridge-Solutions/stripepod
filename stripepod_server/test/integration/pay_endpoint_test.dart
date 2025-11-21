import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stripepod_server/src/generated/protocol.dart';
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

        expect(
          result.paymentIntentId,
          'pi_test_123456789',
        );
        expect(
          result.clientSecret,
          'pi_test_123456789_secret_abc123',
        );

        final paymentDb = await Payment.db.findFirstRow(sessionBuilder.build());
        expect(paymentDb, isNotNull);
        expect(paymentDb!.stripeId, 'pi_test_123456789');
        expect(paymentDb.amount, 10000);
        expect(paymentDb.currency, 'usd');
        expect(paymentDb.status, PaymentStatus.pending);
        expect(paymentDb.createdAt, isNotNull);
      },
    );

    test(
      'when calling `getPaymentById` with existing stripeIntentId then returns payment',
      () async {
        final payment = await Payment.db.insertRow(
          sessionBuilder.build(),
          Payment(
            stripeId: 'pi_test_existing',
            amount: 5000,
            currency: 'usd',
            status: PaymentStatus.succeeded,
            createdAt: DateTime.now(),
          ),
        );

        final payEndpoint = PayEndpoint();

        // Act: Get payment by stripe intent ID
        final result = await payEndpoint.getPaymentById(
          sessionBuilder.build(),
          'pi_test_existing',
        );

        expect(result.id, payment.id);
        expect(result.stripeId, 'pi_test_existing');
        expect(result.amount, 5000);
        expect(result.currency, 'usd');
        expect(result.status, PaymentStatus.succeeded);
      },
    );

    test(
      'when calling `getPaymentById` with non-existent stripeIntentId then throws ApiException',
      () async {
        final payEndpoint = PayEndpoint();

        expect(
          () async => await payEndpoint.getPaymentById(
            sessionBuilder.build(),
            'pi_nonexistent',
          ),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Payment not found',
            ),
          ),
        );
      },
    );
  });
}
