import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Product endpoint', (sessionBuilder, endpoints) {
    test(
      'when calling `getProduct` with id then returned product includes correct fields',
      () async {
        final product = await endpoints.product.getProduct(sessionBuilder, 1);
        expect(product.name, 'Arkbridge Consult 1');
        expect(product.id, 1);
        expect(product.priceInCents, 10000);
      },
    );
  });
}
