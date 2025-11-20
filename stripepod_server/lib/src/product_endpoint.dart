import 'package:serverpod/serverpod.dart';

import 'generated/protocol.dart';

// This is an example endpoint of how to fetch a product
// It is used now to test the stripe integration
class ProductEndpoint extends Endpoint {
  //returns a hardcoded product but normally you would fetch it from the
  // database
  Future<Product> getProduct(Session session, int id) async {
    return Product(
      id: id,
      name: 'Arkbridge Consult $id',
      priceInCents: 10000,
    );
  }
}
