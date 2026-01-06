import 'package:flutter/foundation.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

@immutable
class CartState {
  const CartState({required this.cart, required this.isLoading, required this.error});

  const CartState.initial() : this(cart: null, isLoading: false, error: null);

  final Cart? cart;
  final bool isLoading;
  final String? error;

  List<CartItem> get items => cart?.items ?? const [];
  bool get isEmpty => items.isEmpty;
  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get displayTotalPrice => (cart?.totalPrice ?? 0) ~/ 10;

  static const Object _unset = Object();

  CartState copyWith({Object? cart = _unset, bool? isLoading, Object? error = _unset}) {
    return CartState(
      cart: identical(cart, _unset) ? this.cart : cart as Cart?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}
