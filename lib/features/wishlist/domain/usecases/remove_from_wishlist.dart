import '../repositories/wishlist_repository.dart';

class RemoveFromWishlist {
  const RemoveFromWishlist(this._repo);

  final WishlistRepository _repo;

  Future<void> call({required String wishlistItemId}) {
    return _repo.remove(wishlistItemId: wishlistItemId);
  }
}
