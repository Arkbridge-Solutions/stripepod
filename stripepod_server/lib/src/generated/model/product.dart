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

abstract class Product
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Product._({
    required this.id,
    required this.name,
    required this.priceInCents,
  });

  factory Product({
    required int id,
    required String name,
    required int priceInCents,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      priceInCents: jsonSerialization['priceInCents'] as int,
    );
  }

  int id;

  String name;

  int priceInCents;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    int? id,
    String? name,
    int? priceInCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priceInCents': priceInCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id,
      'name': name,
      'priceInCents': priceInCents,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ProductImpl extends Product {
  _ProductImpl({
    required int id,
    required String name,
    required int priceInCents,
  }) : super._(
         id: id,
         name: name,
         priceInCents: priceInCents,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product copyWith({
    int? id,
    String? name,
    int? priceInCents,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      priceInCents: priceInCents ?? this.priceInCents,
    );
  }
}
