import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../datasources/cart_remote_data_sourced.dart';
import '../mappers/cart_model_mapper.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({CartApi? api, CartLocalDataSource? local})
    : _api = api ?? CartApi.I,
      _local = local ?? CartLocalDataSource();

  final CartApi _api;
  final CartLocalDataSource _local;

  @override
  Future<Cart> addItem({required String productId, int quantity = 1}) async {
    var cartId = await _local.readCartId();

    if (cartId == null) {
      final created = await _api.createCart();
      if (!created.success || created.data == null) {
        throw Exception(created.error ?? 'خطا در ساخت سبد خرید');
      }
      cartId = created.data!.id;
      await _local.saveCartId(cartId);
    }
    final add = await _api.addItem(
      cartId: cartId,
      productId: productId,
      quantity: quantity,
    );
    if (!add.success) {
      throw Exception(add.error ?? 'خطا در افزودن آیتم به سبد خرید');
    }
    return _fetchCartOrThrow(cartId);
  }

  @override
  Future<void> clearCart() async {
    final cartId = await _local.readCartId();
    if (cartId == null) {
      await _local.clearCartId();
      return;
    }

    final result = await _api.clearCart(cartId);
    if (!result.success) {
      throw Exception(result.error ?? 'خطا در حذف/خالی کردن سبد خرید');
    }

    await _local.clearCartId();
  }

  @override
  Future<Cart?> getCart() async {
    final cartId = await _local.readCartId();
    if (cartId == null) return null;

    final result = await _api.getCart(cartId);

    if (!result.success || result.data == null) {
      await _local.clearCartId();

      return null;
    }
    return result.data!.toEntity();
  }

  @override
  Future<Cart> removeItem({required String itemId}) async {
    final cartId = await _requireCartId();

    final result = await _api.removeItem(cartId: cartId, itemId: itemId);
    if (!result.success) {
      throw Exception(result.error ?? 'خطا در حذف آیتم از سبد خرید');
    }

    return _fetchCartOrThrow(cartId);
  }

  @override
  Future<Cart> updateItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      return removeItem(itemId: itemId);
    }

    final cartId = await _requireCartId();

    final result = await _api.updateItem(
      cartId: cartId,
      itemId: itemId,
      quantity: quantity,
    );
    if (!result.success) {
      throw Exception(result.error ?? 'خطا در تغییر تعداد آیتم');
    }

    return _fetchCartOrThrow(cartId);
  }

  Future<Cart> _fetchCartOrThrow(String cartId) async {
    final result = await _api.getCart(cartId);
    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در دریافت سبد خرید');
    }
    return result.data!.toEntity();
  }

  Future<String> _requireCartId() async {
    final cartId = await _local.readCartId();
    if (cartId == null) {
      throw Exception('سبد خرید یافت نشد');
    }
    return cartId;
  }
}
