import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:stripepod_server/src/stripe/stripe_api_client.dart';
import 'package:stripepod_server/src/stripe/stripe_webhook_functions.dart';
import 'package:stripepod_server/src/stripe/stripe_webhook_verifier.dart';

class StripeWebhookRoute extends Route {
  /// Creates a new instance of [StripeWebhookRoute].
  StripeWebhookRoute() : super(methods: {Method.post}, path: '/stripe/webhook');

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final rawBody = await utf8.decoder.bind(request.body.read()).join();
    final stripeSignature = request.headers['Stripe-Signature']?.firstOrNull;

    final webhookSecret = session.passwords['stripeWebhookSecret']!;

    if (stripeSignature == null ||
        !verifyStripeSignature(
          payload: rawBody,
          stripeSignatureHeader: stripeSignature,
          secret: webhookSecret,
        )) {
      return Response.unauthorized();
    }
    final payload = jsonDecode(rawBody) as Map<String, dynamic>;
    final type = payload['type'] as String;

    switch (type) {
      case 'payment_intent.succeeded':
      case 'payment_intent.failed':
        await checkPaymentIntentAndUpdateStatus(
          session: session,
          paymentIntentId: payload['data']['object']['id'] as String,
          stripeApiClient: session.stripeApiClient,
        );
        break;
      default:
        break;
    }
    return Response.ok();
  }
}
