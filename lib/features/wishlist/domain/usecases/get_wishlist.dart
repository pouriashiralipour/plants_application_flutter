import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlist {
  const GetWishlist(this._repo);

  final WishlistRepository _repo;

  Future<List<WishlistItem>> call() {
    return _repo.getWishlist();
  }
}
