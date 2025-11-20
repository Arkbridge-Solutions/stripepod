import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:stripepod_server/src/stripe/stripe_api_client.dart';
import 'package:stripepod_server/src/stripe/stripe_model.dart';
import 'package:test/test.dart';

void main() {
  group('StripeApiClient', () {
    const testApiUrl = 'https://api.stripe.com';
    const testStripeKey = 'sk_test_123456789';

    group('createPaymentIntent', () {
      test(
        'It successfully creates payment intent with 200 response',
        () async {
          final mockClient = MockClient((request) async {
            expect(request.url.toString(), '$testApiUrl/v1/payment_intents');
            expect(request.method, 'POST');
            expect(
              request.headers['Authorization'],
              'Bearer $testStripeKey',
            );
            expect(request.bodyFields['amount'], '2000');
            expect(request.bodyFields['currency'], 'usd');
            expect(request.bodyFields['automatic_payment_methods'], 'true');

            return http.Response(
              '{"id": "pi_123", "amount": 2000, "currency": "usd"}',
              200,
              request: request,
            );
          });

          final client = StripeApiClient(
            apiUrl: testApiUrl,
            stripeServerKey: testStripeKey,
            httpClient: mockClient,
          );

          final response = await client.createPaymentIntent(2000);

          expect(response.statusCode, 200);
          expect(
            response.body,
            contains('pi_123'),
          );
        },
      );

      test('It throws StripeApiException on non-200 status code', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            '{"error": {"message": "Invalid API key"}}',
            401,
            request: request,
          );
        });

        final client = StripeApiClient(
          apiUrl: testApiUrl,
          stripeServerKey: testStripeKey,
          httpClient: mockClient,
        );

        expect(
          () => client.createPaymentIntent(2000),
          throwsA(isA<StripeApiException>()),
        );
      });

      test('throws StripeApiException on network error', () async {
        final mockClient = MockClient((request) async {
          throw http.ClientException('Network error');
        });

        final client = StripeApiClient(
          apiUrl: testApiUrl,
          stripeServerKey: testStripeKey,
          httpClient: mockClient,
        );

        expect(
          () => client.createPaymentIntent(2000),
          throwsA(
            isA<StripeApiException>()
                .having(
                  (e) => e.message,
                  'message',
                  'Failed to execute request',
                )
                .having(
                  (e) => e.originalException,
                  'originalException',
                  isNotNull,
                ),
          ),
        );
      });
    });
  });

  group('StripeSessionExtension', () {
    test('returns StripeApiClient when stripe key is present', () {
      // Arrange
      final session = _MockSession(
        passwords: {'stripeServerKey': 'sk_test_123'},
      );

      // Act
      final client = session.stripeApiClient;

      // Assert
      expect(client, isA<StripeApiClient>());
    });

    test('throws StripeApiException when stripe key is missing', () {
      // Arrange
      final session = _MockSession(passwords: {});

      // Act & Assert
      expect(
        () => session.stripeApiClient,
        throwsA(
          isA<StripeApiException>().having(
            (e) => e.message,
            'message',
            'Stripe server key not found',
          ),
        ),
      );
    });
  });
}

// Mock Session for testing the extension
class _MockSession implements Session {
  _MockSession({required this.passwords});

  @override
  final Map<String, String> passwords;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
