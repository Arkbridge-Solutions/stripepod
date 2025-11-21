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
import 'package:serverpod/protocol.dart' as _i2;
import 'model/payment.dart' as _i3;
import 'model/payment_status.dart' as _i4;
import 'model/product.dart' as _i5;
import 'model/stripe_payment_info.dart' as _i6;
export 'model/payment.dart';
export 'model/payment_status.dart';
export 'model/product.dart';
export 'model/stripe_payment_info.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'payments',
      dartName: 'Payment',
      schema: 'public',
      module: 'stripepod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'payments_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'stripeId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PaymentStatus',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'payments_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.Payment) {
      return _i3.Payment.fromJson(data) as T;
    }
    if (t == _i4.PaymentStatus) {
      return _i4.PaymentStatus.fromJson(data) as T;
    }
    if (t == _i5.Product) {
      return _i5.Product.fromJson(data) as T;
    }
    if (t == _i6.StripePaymentInfo) {
      return _i6.StripePaymentInfo.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.Payment?>()) {
      return (data != null ? _i3.Payment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.PaymentStatus?>()) {
      return (data != null ? _i4.PaymentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Product?>()) {
      return (data != null ? _i5.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.StripePaymentInfo?>()) {
      return (data != null ? _i6.StripePaymentInfo.fromJson(data) : null) as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i3.Payment():
        return 'Payment';
      case _i4.PaymentStatus():
        return 'PaymentStatus';
      case _i5.Product():
        return 'Product';
      case _i6.StripePaymentInfo():
        return 'StripePaymentInfo';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
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
      return deserialize<_i3.Payment>(data['data']);
    }
    if (dataClassName == 'PaymentStatus') {
      return deserialize<_i4.PaymentStatus>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i5.Product>(data['data']);
    }
    if (dataClassName == 'StripePaymentInfo') {
      return deserialize<_i6.StripePaymentInfo>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3.Payment:
        return _i3.Payment.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'stripepod';
}
