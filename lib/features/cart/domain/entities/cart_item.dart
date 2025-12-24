import 'cart_product.dart';

class CartItem {
  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.itemPrice,
  });

  final String id;
  final CartProduct product;
  final int quantity;
  final int itemPrice;
}
