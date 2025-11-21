import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
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
        break;
      case 'payment_intent.failed':
        break;
      default:
        break;
    }
    return Response.ok();
  }
}
