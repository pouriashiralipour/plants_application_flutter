import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItem {
  const RemoveCartItem(this._repo);

  final CartRepository _repo;

  Future<Cart> call({required String itemId}) {
    return _repo.removeItem(itemId: itemId);
  }
}
