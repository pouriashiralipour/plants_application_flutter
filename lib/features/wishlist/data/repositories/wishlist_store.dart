import 'package:flutter/material.dart';

import '../../../product/data/models/product_model.dart';
import '../datasources/wishlist_remote_data_source.dart';
import '../models/wishlist_item_model.dart';

class WishlistStore extends ChangeNotifier {
  WishlistStore._();
  static final WishlistStore I = WishlistStore._();

  final WishlistApi _api = WishlistApi.I;

  final List<WishlistItemModel> _items = [];
  bool _isLoading = false;
  String? _error;

  List<WishlistItemModel> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ProductModel> get products => _items.map((w) => w.product).toList(growable: false);

  bool isWishlisted(String productId) {
    return _items.any((w) => w.product.id == productId);
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _api.getAll();

    if (result.success && result.data != null) {
      _items
        ..clear()
        ..addAll(result.data!);
    } else {
      _error = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggle(ProductModel product) async {
    final existing = _items.where((w) => w.product.id == product.id).toList();

    if (existing.isNotEmpty) {
      final item = existing.first;
      final result = await _api.remove(item.id);
      if (result.success) {
        _items.remove(item);
        notifyListeners();
      }
      return;
    }
    final result = await _api.add(product.id);
    if (result.success && result.data != null) {
      _items.add(result.data!);
      notifyListeners();
    }
  }
}
