import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:stripepod_client/stripepod_client.dart';
import 'package:stripepod_flutter/src/env.dart';
import 'package:stripepod_flutter/src/ui/check_payment_web.dart';
import 'package:stripepod_flutter/src/ui/pay_screen.dart';
import 'package:stripepod_flutter/src/ui/platforms/pay_screen_web.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
late final Client client;

late String serverUrl;
late GoRouter router;

void main() async {
  // When you are running the app on a physical device, you need to set the
  // server URL to the IP address of your computer. You can find the IP
  // address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
  // You can set the variable when running or building your app like this:
  // E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl = serverUrlFromEnv.isEmpty
      ? 'http://$localhost:8080/'
      : serverUrlFromEnv;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  Stripe.publishableKey = stripePublishableKey;

  await Stripe.instance.applySettings();

  router = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => kIsWeb
            ? PayScreenWeb(
                client: client,
              )
            : PayScreen(
                client: client,
              ),
        routes: [
          GoRoute(
            path: 'check-payment',
            builder: (context, state) {
              final paymentIntentId =
                  state.uri.queryParameters['payment_intent'] ?? '';
              return CheckPaymentWebScreen(
                paymentIntentId: paymentIntentId,
                client: client,
              );
            },
          ),
        ],
      ),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StripePod',
      theme: ThemeData(primarySwatch: Colors.indigo),
      routerConfig: router,
    );
  }
}
