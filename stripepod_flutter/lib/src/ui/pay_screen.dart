import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripepod_client/stripepod_client.dart';
import 'package:stripepod_flutter/src/retry.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({
    required this.client,
    super.key,
  });

  final Client client;

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late final ValueNotifier<bool> loadingNotifier;
  late final ValueNotifier<String> paymentResultNotifier;

  @override
  void initState() {
    super.initState();
    loadingNotifier = ValueNotifier(false);
    paymentResultNotifier = ValueNotifier('');
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    paymentResultNotifier.dispose();
    super.dispose();
  }

  void pay() async {
    loadingNotifier.value = true;

    // normally you would request them in the app checkout screen
    final billingDetails = BillingDetails(
      name: 'My company',
      email: 'email@mycompany.com',
      phone: '+48888000888',
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    );

    try {
      final paymentInfo = await widget.client.pay.pay(1);
      paymentResultNotifier.value = 'Received intent starting paymentsheet';
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentInfo.clientSecret,
          billingDetails: billingDetails,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final payment = await simpleRetry(
        action: () async {
          return widget.client.pay.getPaymentById(paymentInfo.paymentIntentId);
        },
        retryWhen: (payment) => payment.status == PaymentStatus.pending,
      );

      paymentResultNotifier.value =
          'Payment completed status: ${payment.status}';
    } catch (e) {
      paymentResultNotifier.value = 'Failed to pay: $e';
    }

    loadingNotifier.value = false;
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
              const SizedBox(height: 32),
              ValueListenableBuilder(
                valueListenable: loadingNotifier,
                builder: (context, loading, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    onPressed: loading ? null : pay,
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : Text('Pay', style: TextStyle(color: Colors.white)),
                  );
                },
              ),
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
      ),
    );
  }
}
