import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCart {
  const GetCart(this._repo);

  final CartRepository _repo;

  Future<Cart?> call() {
    return _repo.getCart();
  }
}
