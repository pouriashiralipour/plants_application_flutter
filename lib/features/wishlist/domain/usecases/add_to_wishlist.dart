import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class AddToWishlist {
  const AddToWishlist(this._repo);

  final WishlistRepository _repo;

  Future<WishlistItem> call({required String productId}) {
    return _repo.add(productId: productId);
  }
}
