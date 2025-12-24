import '../../../product/domain/entities/product.dart';

class WishlistItem {
  const WishlistItem({required this.id, required this.product, required this.createdAt});

  final String id;
  final Product product;
  final DateTime createdAt;
}
