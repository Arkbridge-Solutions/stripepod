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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class StripePaymentInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  StripePaymentInfo._({
    required this.paymentIntentId,
    required this.clientSecret,
  });

  factory StripePaymentInfo({
    required String paymentIntentId,
    required String clientSecret,
  }) = _StripePaymentInfoImpl;

  factory StripePaymentInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return StripePaymentInfo(
      paymentIntentId: jsonSerialization['paymentIntentId'] as String,
      clientSecret: jsonSerialization['clientSecret'] as String,
    );
  }

  String paymentIntentId;

  String clientSecret;

  /// Returns a shallow copy of this [StripePaymentInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StripePaymentInfo copyWith({
    String? paymentIntentId,
    String? clientSecret,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'paymentIntentId': paymentIntentId,
      'clientSecret': clientSecret,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'paymentIntentId': paymentIntentId,
      'clientSecret': clientSecret,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _StripePaymentInfoImpl extends StripePaymentInfo {
  _StripePaymentInfoImpl({
    required String paymentIntentId,
    required String clientSecret,
  }) : super._(
         paymentIntentId: paymentIntentId,
         clientSecret: clientSecret,
       );

  /// Returns a shallow copy of this [StripePaymentInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StripePaymentInfo copyWith({
    String? paymentIntentId,
    String? clientSecret,
  }) {
    return StripePaymentInfo(
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      clientSecret: clientSecret ?? this.clientSecret,
    );
  }
}
