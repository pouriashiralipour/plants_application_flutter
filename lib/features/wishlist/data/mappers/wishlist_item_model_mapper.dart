import '../../../product/data/mappers/product_model_mapper.dart';
import '../../domain/entities/wishlist_item.dart';
import '../models/wishlist_item_model.dart';

extension WishlistItemModelMapper on WishlistItemModel {
  WishlistItem toEntity() {
    return WishlistItem(
      id: id,
      product: product.toEntity(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
