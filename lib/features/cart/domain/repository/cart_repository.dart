import '../entities/cart.dart';

abstract class CartRepository {
  Future<Cart?> getCart();

  Future<Cart> addItem({required String productId, int quantity = 1});

  Future<Cart> updateItemQuantity({required String itemId, required int quantity});

  Future<Cart> removeItem({required String itemId});

  Future<void> clearCart();
}
