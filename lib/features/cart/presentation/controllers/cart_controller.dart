import 'package:flutter/foundation.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_cart_item.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/remove_cart_item.dart';
import '../../domain/usecases/update_cart_item_quantity.dart';

class CartController extends ChangeNotifier {
  CartController({
    required GetCart getCart,
    required AddCartItem addCartItem,
    required UpdateCartItemQuantity updateCartItemQuantity,
    required RemoveCartItem removeCartItem,
    required ClearCart clearCart,
  }) : _getCart = getCart,
       _addCartItem = addCartItem,
       _updateCartItemQuantity = updateCartItemQuantity,
       _removeCartItem = removeCartItem,
       _clearCart = clearCart;

  final AddCartItem _addCartItem;
  final ClearCart _clearCart;
  final GetCart _getCart;
  final RemoveCartItem _removeCartItem;
  final UpdateCartItemQuantity _updateCartItemQuantity;

  bool _isLoading = false;

  Cart? _cart;
  String? _error;

  Cart? get cart => _cart;

  /// totalPrice از API معمولاً ریال است؛ برای نمایش تومان تقسیم بر 10
  int get displayTotalPrice => (_cart?.totalPrice ?? 0) ~/ 10;

  String? get error => _error;
  bool get isEmpty => items.isEmpty;
  bool get isLoading => _isLoading;
  List<CartItem> get items => _cart?.items ?? const [];
  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);

  Future<void> addItem({required String productId, int quantity = 1}) async {
    _setLoading(true);
    _error = null;

    try {
      _cart = await _addCartItem(productId: productId, quantity: quantity);
    } catch (e) {
      _error = 'خطا در افزودن به سبد خرید: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clear() async {
    _setLoading(true);
    _error = null;

    try {
      await _clearCart();
      _cart = null;
    } catch (e) {
      _error = 'خطا در خالی کردن سبد خرید: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> decreaseItemQuantity({required String itemId, required int currentQuantity}) async {
    await setItemQuantity(itemId: itemId, quantity: currentQuantity - 1);
  }

  Future<void> increaseItemQuantity({required String itemId, required int currentQuantity}) async {
    await setItemQuantity(itemId: itemId, quantity: currentQuantity + 1);
  }

  Future<void> load() async {
    _setLoading(true);
    _error = null;

    try {
      _cart = await _getCart();
    } catch (e) {
      _cart = null;
      _error = 'خطا در دریافت سبد خرید: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeItem({required String itemId}) async {
    _setLoading(true);
    _error = null;

    try {
      _cart = await _removeCartItem(itemId: itemId);
    } catch (e) {
      _error = 'خطا در حذف آیتم: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setItemQuantity({required String itemId, required int quantity}) async {
    _setLoading(true);
    _error = null;

    try {
      _cart = await _updateCartItemQuantity(itemId: itemId, quantity: quantity);
    } catch (e) {
      _error = 'خطا در تغییر تعداد: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
