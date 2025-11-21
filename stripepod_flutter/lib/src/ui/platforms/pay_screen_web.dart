import 'package:flutter/material.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:stripepod_client/stripepod_client.dart';
import 'package:web/web.dart' as web;

class PayScreenWeb extends StatefulWidget {
  const PayScreenWeb({
    required this.client,
    super.key,
  });

  final Client client;

  @override
  State<PayScreenWeb> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreenWeb> {
  late final ValueNotifier<String?> clientSecretNotifier;
  late final ValueNotifier<String> paymentResultNotifier;

  @override
  void initState() {
    super.initState();
    clientSecretNotifier = ValueNotifier(null);
    paymentResultNotifier = ValueNotifier('');
  }

  @override
  void dispose() {
    clientSecretNotifier.dispose();
    paymentResultNotifier.dispose();
    super.dispose();
  }

  void pay() async {
    try {
      final paymentInfo = await widget.client.pay.pay(1);
      paymentResultNotifier.value = 'Received intent starting paymentsheet';

      clientSecretNotifier.value = paymentInfo.clientSecret;
    } catch (e) {
      paymentResultNotifier.value = 'Failed to pay: $e';
    }
  }

  void _confirmPayment() async {
    await WebStripe.instance.confirmPaymentElement(
      ConfirmPaymentElementOptions(
        confirmParams: ConfirmPaymentParams(
          return_url: '${web.window.location.href}check-payment',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Pay', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ValueListenableBuilder(
            valueListenable: clientSecretNotifier,
            builder: (context, clientSecret, child) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Text('Arkbridge consult'),
                          Spacer(),
                          Text('\$100'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const Divider(),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '\$100',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ...clientSecret == null
                          ? [
                              const SizedBox(height: 32),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                ),
                                onPressed: pay,
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ]
                          : [
                              const SizedBox(height: 32),
                              PaymentElement(
                                autofocus: true,
                                enablePostalCode: true,
                                onCardChanged: (_) {},
                                clientSecret: clientSecret,
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                ),
                                onPressed: _confirmPayment,
                                child: Text(
                                  'Confirm Payment',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                      const SizedBox(height: 32),
                      Container(
                        color: Colors.grey.withValues(alpha: 0.4),
                        height: 100,
                        padding: const EdgeInsets.all(16.0),
                        child: ValueListenableBuilder(
                          valueListenable: paymentResultNotifier,
                          builder: (context, result, child) {
                            return Text('Progress: \n\n $result');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
