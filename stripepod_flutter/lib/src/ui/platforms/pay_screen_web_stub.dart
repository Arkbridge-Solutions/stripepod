import 'package:flutter/material.dart';
import 'package:stripepod_client/stripepod_client.dart';

/// Stub implementation for non-web platforms
/// This should never be called on non-web platforms
class PayScreenWebImpl extends StatelessWidget {
  const PayScreenWebImpl({
    required this.client,
    super.key,
  });

  final Client client;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Web-only feature'),
      ),
    );
  }
}
