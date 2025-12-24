import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemQuantity {
  const UpdateCartItemQuantity(this._repo);

  final CartRepository _repo;

  Future<Cart> call({required String itemId, required int quantity}) {
    return _repo.updateItemQuantity(itemId: itemId, quantity: quantity);
  }
}
