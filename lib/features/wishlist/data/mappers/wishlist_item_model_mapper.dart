import '../../domain/entities/wishlist_item.dart';
import '../models/wishlist_item_model.dart';
import 'wishlist_product_model_mapper.dart';

extension WishlistItemModelMapper on WishlistItemModel {
  WishlistItem toEntity() {
    return WishlistItem(
      id: id,
      product: product.toWishlistEntity(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
