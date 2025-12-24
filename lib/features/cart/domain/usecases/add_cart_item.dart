import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class AddCartItem {
  const AddCartItem(this._repo);

  final CartRepository _repo;

  Future<Cart> call({required String productId, int quantity = 1}) {
    return _repo.addItem(productId: productId, quantity: quantity);
  }
}
