import 'package:flutter/material.dart';
import 'package:stripepod_client/stripepod_client.dart';
import 'platforms/pay_screen_web_impl.dart'
    if (dart.library.io) 'platforms/pay_screen_web_stub.dart';

class PayScreenWeb extends StatelessWidget {
  const PayScreenWeb({
    required this.client,
    super.key,
  });

  final Client client;

  @override
  Widget build(BuildContext context) {
    return PayScreenWebImpl(client: client);
  }
}
