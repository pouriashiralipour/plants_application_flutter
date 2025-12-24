import 'cart_item.dart';

class Cart {
  const Cart({required this.id, required this.items, required this.totalPrice});

  final String id;
  final List<CartItem> items;
  final int totalPrice;
}
