import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stripepod_server/src/generated/protocol.dart';
import 'package:stripepod_server/src/stripe/stripe_api_client.dart';
import 'package:stripepod_server/src/stripe/stripe_model.dart';
import 'package:stripepod_server/src/stripe/stripe_webhook_functions.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given checkPaymentIntentAndUpdateStatus',
    (sessionBuilder, endpoints) {
      test(
        'when payment exists and status is succeeded then updates payment status',
        () async {
          // Arrange: Create a payment in the database
          final payment = await Payment.db.insertRow(
            sessionBuilder.build(),
            Payment(
              stripeId: 'pi_test_123456789',
              amount: 10000,
              currency: 'usd',
              status: PaymentStatus.pending,
              createdAt: DateTime.now(),
            ),
          );

          // Mock HTTP client to return succeeded status
          final mockHttpClient = MockClient((request) async {
            return http.Response(
              jsonEncode({
                'id': 'pi_test_123456789',
                'object': 'payment_intent',
                'amount': 10000,
                'currency': 'usd',
                'status': 'succeeded',
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

          // Act: Call the function
          await checkPaymentIntentAndUpdateStatus(
            session: sessionBuilder.build(),
            paymentIntentId: 'pi_test_123456789',
            stripeApiClient: mockStripeClient,
          );

          // Assert: Verify payment status was updated
          final updatedPayment = await Payment.db.findById(
            sessionBuilder.build(),
            payment.id!,
          );

          expect(updatedPayment, isNotNull);
          expect(updatedPayment!.status, PaymentStatus.succeeded);
          expect(updatedPayment.stripeId, 'pi_test_123456789');
          expect(updatedPayment.amount, 10000);
        },
      );

      test(
        'when payment does not exist then throws StripeApiException',
        () async {
          // Mock HTTP client to return a valid response
          final mockHttpClient = MockClient((request) async {
            return http.Response(
              jsonEncode({
                'id': 'pi_nonexistent',
                'object': 'payment_intent',
                'amount': 5000,
                'currency': 'usd',
                'status': 'succeeded',
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

          // Act & Assert: Expect exception to be thrown
          expect(
            () async => await checkPaymentIntentAndUpdateStatus(
              session: sessionBuilder.build(),
              paymentIntentId: 'pi_nonexistent',
              stripeApiClient: mockStripeClient,
            ),
            throwsA(
              isA<StripeApiException>().having(
                (e) => e.message,
                'message',
                'Payment not found',
              ),
            ),
          );
        },
      );
    },
  );
}
