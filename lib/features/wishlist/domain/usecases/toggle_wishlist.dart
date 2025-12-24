import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class ToggleWishlist {
  const ToggleWishlist(this._repo);

  final WishlistRepository _repo;

  Future<List<WishlistItem>> call({required String productId}) {
    return _repo.toggle(productId: productId);
  }
}
