import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stripepod_client/stripepod_client.dart';
import 'package:stripepod_flutter/src/retry.dart';

class CheckPaymentWebScreen extends StatefulWidget {
  const CheckPaymentWebScreen({
    required this.paymentIntentId,
    required this.client,
    super.key,
  });

  final String paymentIntentId;
  final Client client;

  @override
  State<CheckPaymentWebScreen> createState() => _CheckPaymentWebScreenState();
}

class _CheckPaymentWebScreenState extends State<CheckPaymentWebScreen> {
  late final ValueNotifier<String> paymentResultNotifier;
  late final ValueNotifier<bool> loadingNotifier;

  @override
  void initState() {
    super.initState();
    paymentResultNotifier = ValueNotifier('');
    loadingNotifier = ValueNotifier(false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkPayment();
    });
  }

  @override
  void dispose() {
    paymentResultNotifier.dispose();
    loadingNotifier.dispose();
    super.dispose();
  }

  void checkPayment() async {
    try {
      loadingNotifier.value = true;
      paymentResultNotifier.value = 'Checking payment status';

      final payment = await simpleRetry(
        action: () async {
          return widget.client.pay.getPaymentById(widget.paymentIntentId);
        },
        retryWhen: (payment) => payment.status == PaymentStatus.pending,
      );

      paymentResultNotifier.value =
          'Payment completed status: ${payment.status}';
      loadingNotifier.value = false;
    } catch (e) {
      paymentResultNotifier.value = 'Failed to pay: $e';
    }
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
            valueListenable: loadingNotifier,
            builder: (context, loading, child) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      ...loading
                          ? [
                              Text('Checking payment...'),
                              const SizedBox(height: 16),
                              CircularProgressIndicator(),
                            ]
                          : [
                              ValueListenableBuilder(
                                valueListenable: paymentResultNotifier,
                                builder: (context, result, child) {
                                  return Text(result);
                                },
                              ),
                            ],
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
