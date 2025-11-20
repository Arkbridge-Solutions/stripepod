/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:stripepod_client/src/protocol/product.dart' as _i3;
import 'protocol.dart' as _i4;

/// Endpoint that will create a payment intent and return the payment intent
/// client secret
/// {@category Endpoint}
class EndpointPay extends _i1.EndpointRef {
  EndpointPay(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pay';

  _i2.Future<String> pay(int productId) => caller.callServerEndpoint<String>(
    'pay',
    'pay',
    {'productId': productId},
  );
}

/// {@category Endpoint}
class EndpointProduct extends _i1.EndpointRef {
  EndpointProduct(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _i2.Future<_i3.Product> getProduct(int id) =>
      caller.callServerEndpoint<_i3.Product>(
        'product',
        'getProduct',
        {'id': id},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i4.Protocol(),
         securityContext: securityContext,
         authenticationKeyManager: authenticationKeyManager,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    pay = EndpointPay(this);
    product = EndpointProduct(this);
  }

  late final EndpointPay pay;

  late final EndpointProduct product;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'pay': pay,
    'product': product,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
