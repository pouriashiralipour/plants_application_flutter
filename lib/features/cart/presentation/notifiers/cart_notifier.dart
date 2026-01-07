import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/add_cart_item.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/remove_cart_item.dart';
import '../../domain/usecases/update_cart_item_quantity.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';

import 'cart_state.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepositoryImpl());

final getCartProvider = Provider<GetCart>((ref) => GetCart(ref.watch(cartRepositoryProvider)));
final addCartItemProvider = Provider<AddCartItem>(
  (ref) => AddCartItem(ref.watch(cartRepositoryProvider)),
);
final updateCartItemQuantityProvider = Provider<UpdateCartItemQuantity>(
  (ref) => UpdateCartItemQuantity(ref.watch(cartRepositoryProvider)),
);
final removeCartItemProvider = Provider<RemoveCartItem>(
  (ref) => RemoveCartItem(ref.watch(cartRepositoryProvider)),
);
final clearCartProvider = Provider<ClearCart>(
  (ref) => ClearCart(ref.watch(cartRepositoryProvider)),
);

final cartNotifierProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

class CartNotifier extends Notifier<CartState> {
  late final AddCartItem _addCartItem;
  late final ClearCart _clearCart;
  late final GetCart _getCart;
  late final RemoveCartItem _removeCartItem;
  late final UpdateCartItemQuantity _updateCartItemQuantity;

  @override
  CartState build() {
    _addCartItem = ref.watch(addCartItemProvider);
    _clearCart = ref.watch(clearCartProvider);
    _getCart = ref.watch(getCartProvider);
    _removeCartItem = ref.watch(removeCartItemProvider);
    _updateCartItemQuantity = ref.watch(updateCartItemQuantityProvider);

    unawaited(Future.microtask(load));
    return const CartState(cart: null, isLoading: true, error: null);
  }

  Future<void> load() async {
    await _run(errorPrefix: 'خطا در دریافت سبد خرید', action: () => _getCart());
  }

  Future<void> addItem({required String productId, int quantity = 1}) async {
    await _run(
      errorPrefix: 'خطا در افزودن به سبد خرید',
      action: () => _addCartItem(productId: productId, quantity: quantity),
    );
  }

  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _clearCart();
      state = state.copyWith(cart: null, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'خطا در خالی کردن سبد خرید: $e');
    }
  }

  Future<void> removeItem({required String itemId}) async {
    await _run(
      errorPrefix: 'خطا در حذف آیتم',
      action: () => _removeCartItem(itemId: itemId),
    );
  }

  Future<void> increaseItemQuantity({required String itemId, required int currentQuantity}) async {
    await setItemQuantity(itemId: itemId, quantity: currentQuantity + 1);
  }

  Future<void> decreaseItemQuantity({required String itemId, required int currentQuantity}) async {
    await setItemQuantity(itemId: itemId, quantity: currentQuantity - 1);
  }

  Future<void> setItemQuantity({required String itemId, required int quantity}) async {
    await _run(
      errorPrefix: 'خطا در تغییر تعداد',
      action: () => _updateCartItemQuantity(itemId: itemId, quantity: quantity),
    );
  }

  Future<void> _run({
    required String errorPrefix,
    required Future<dynamic> Function() action,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await action();
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '$errorPrefix: $e');
    }
  }
}
