import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../product/data/models/product_model.dart';
import '../datasources/cart_remote_data_sourced.dart';
import '../models/cart_model.dart';

class CartRepository extends ChangeNotifier {
  CartRepository._();

  static final CartRepository I = CartRepository._();

  static const _cartIdKey = 'cart_id';

  final CartApi _api = CartApi.I;

  bool _initialized = false;
  bool _isLoading = false;

  CartModel? _cart;
  String? _error;

  CartModel? get cart => _cart;
  String? get cartId => _cart?.id;
  String? get error => _error;
  bool get isEmpty => items.isEmpty;
  bool get isLoading => _isLoading;
  List<CartItemModel> get items => _cart?.items ?? const [];
  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);
  int get displaytotalPrice => _cart?.displaytotalPrice ?? 0;

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      var id = cartId;

      if (id == null) {
        final createResult = await _api.createCart();
        if (!createResult.success || createResult.data == null) {
          _error = createResult.error ?? 'خطا در ساخت سبد خرید. دوباره تلاش کنید.';
          return;
        }

        _cart = createResult.data;
        id = _cart!.id;
        await _saveCartId(id);
      }

      final result = await _api.addItem(cartId: id, productId: product.id, quantity: quantity);

      if (!result.success) {
        _error = result.error ?? 'خطا در افزودن محصول به سبد خرید. دوباره تلاش کنید.';
        return;
      }

      await _reloadCart();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeQuantity(CartItemModel item, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(item);
      return;
    }

    _error = null;
    final id = cartId;
    if (id == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _api.updateItem(cartId: id, itemId: item.id, quantity: newQuantity);

      if (!result.success) {
        _error = result.error ?? 'خطا در تغییر تعداد آیتم. دوباره تلاش کنید.';
        return;
      }

      await _reloadCart();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _error = null;
    final id = cartId;
    if (id == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _api.clearCart(id);

      if (!result.success) {
        _error = result.error ?? 'خطا در خالی کردن سبد خرید. دوباره تلاش کنید.';
        return;
      }

      _cart = null;
      await _clearSavedCartId();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final sp = await SharedPreferences.getInstance();
    final savedId = sp.getString(_cartIdKey);

    if (savedId != null && savedId.isNotEmpty) {
      final result = await _api.getCart(savedId);
      if (result.success && result.data != null) {
        _cart = result.data;
      } else {
        await sp.remove(_cartIdKey);
      }
    }

    notifyListeners();
  }

  Future<void> removeItem(CartItemModel item) async {
    _error = null;
    final id = cartId;
    if (id == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _api.removeItem(cartId: id, itemId: item.id);

      if (!result.success) {
        _error = result.error ?? 'خطا در حذف آیتم از سبد خرید. دوباره تلاش کنید.';
        return;
      }

      await _reloadCart();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _clearSavedCartId() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_cartIdKey);
  }

  Future<void> _reloadCart() async {
    final id = cartId;
    if (id == null) return;

    final result = await _api.getCart(id);
    if (result.success && result.data != null) {
      _cart = result.data;
    } else {
      _error = result.error ?? 'خطا در دریافت سبد خرید';
    }
  }

  Future<void> _saveCartId(String id) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_cartIdKey, id);
  }
}
