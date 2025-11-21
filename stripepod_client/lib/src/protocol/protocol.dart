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
import 'model/payment.dart' as _i2;
import 'model/payment_status.dart' as _i3;
import 'model/product.dart' as _i4;
import 'model/stripe_payment_info.dart' as _i5;
export 'model/payment.dart';
export 'model/payment_status.dart';
export 'model/product.dart';
export 'model/stripe_payment_info.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Payment) {
      return _i2.Payment.fromJson(data) as T;
    }
    if (t == _i3.PaymentStatus) {
      return _i3.PaymentStatus.fromJson(data) as T;
    }
    if (t == _i4.Product) {
      return _i4.Product.fromJson(data) as T;
    }
    if (t == _i5.StripePaymentInfo) {
      return _i5.StripePaymentInfo.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Payment?>()) {
      return (data != null ? _i2.Payment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.PaymentStatus?>()) {
      return (data != null ? _i3.PaymentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Product?>()) {
      return (data != null ? _i4.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.StripePaymentInfo?>()) {
      return (data != null ? _i5.StripePaymentInfo.fromJson(data) : null) as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.Payment():
        return 'Payment';
      case _i3.PaymentStatus():
        return 'PaymentStatus';
      case _i4.Product():
        return 'Product';
      case _i5.StripePaymentInfo():
        return 'StripePaymentInfo';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Payment') {
      return deserialize<_i2.Payment>(data['data']);
    }
    if (dataClassName == 'PaymentStatus') {
      return deserialize<_i3.PaymentStatus>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i4.Product>(data['data']);
    }
    if (dataClassName == 'StripePaymentInfo') {
      return deserialize<_i5.StripePaymentInfo>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
