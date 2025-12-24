import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<WishlistItem> add({required String productId});

  Future<List<WishlistItem>> getWishlist();

  Future<void> remove({required String wishlistItemId});

  Future<List<WishlistItem>> toggle({required String productId});
}
