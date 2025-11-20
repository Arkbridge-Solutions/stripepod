import 'package:flutter/material.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

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
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text('\$100', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                onPressed: () {},
                child: Text('Pay', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
