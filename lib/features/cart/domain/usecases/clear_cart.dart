import '../repositories/cart_repository.dart';

class ClearCart {
  const ClearCart(this._repo);

  final CartRepository _repo;

  Future<void> call() {
    return _repo.clearCart();
  }
}
