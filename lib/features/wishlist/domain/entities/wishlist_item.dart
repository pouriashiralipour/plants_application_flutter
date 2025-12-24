import 'wishlist_product.dart';

class WishlistItem {
  const WishlistItem({required this.id, required this.product, required this.createdAt});

  final String id;
  final WishlistProduct product;
  final DateTime createdAt;
}
