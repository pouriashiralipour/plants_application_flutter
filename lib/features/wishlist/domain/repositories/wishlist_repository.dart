import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> add({required String productId});

  Future<void> remove({required String wishlistItemId});

  Future<List<WishlistItem>> toggle({required String productId});
}
