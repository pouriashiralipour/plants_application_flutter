import '../../../product/data/models/product_model.dart';
import '../../domain/entities/wishlist_product.dart';

extension WishlistProductModelMapper on ProductModel {
  WishlistProduct toWishlistEntity() {
    final image = (mainImage != null && mainImage!.trim().isNotEmpty)
        ? mainImage!.trim()
        : (images.isNotEmpty ? images.first.image : '');

    return WishlistProduct(id: id, name: name, price: price, image: image);
  }
}
