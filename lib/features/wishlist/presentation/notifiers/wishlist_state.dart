import 'package:flutter/material.dart';

import '../../domain/entities/wishlist_item.dart';

@immutable
class WishlistState {
  const WishlistState({required this.items, required this.isLoading, required this.error});

  const WishlistState.initial() : items = const [], isLoading = false, error = null;

  final String? error;
  final bool isLoading;
  final List<WishlistItem> items;

  static const Object _unset = Object();

  bool get isEmpty => items.isEmpty;

  WishlistState copyWith({List<WishlistItem>? items, bool? isLoading, Object? error = _unset}) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}
