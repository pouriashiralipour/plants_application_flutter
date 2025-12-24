import 'package:flutter/foundation.dart';

import '../../domain/entities/wishlist_item.dart';
import '../../domain/usecases/get_wishlist.dart';
import '../../domain/usecases/toggle_wishlist.dart';

class WishlistController extends ChangeNotifier {
  WishlistController({required GetWishlist getWishlist, required ToggleWishlist toggleWishlist})
    : _getWishlist = getWishlist,
      _toggleWishlist = toggleWishlist;

  final GetWishlist _getWishlist;
  final List<WishlistItem> _items = [];
  final ToggleWishlist _toggleWishlist;

  bool _isLoading = false;

  String? _error;

  String? get error => _error;
  bool get isLoading => _isLoading;
  List<WishlistItem> get items => List.unmodifiable(_items);

  bool isWishlisted(String productId) {
    return _items.any((w) => w.product.id == productId);
  }

  Future<void> load() async {
    _setLoading(true);
    _error = null;

    try {
      final data = await _getWishlist();
      _items
        ..clear()
        ..addAll(data);
    } catch (e) {
      _items.clear();
      _error = 'خطا در دریافت علاقه‌مندی‌ها: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggle(String productId) async {
    _error = null;

    try {
      _setLoading(true);
      final data = await _toggleWishlist(productId: productId);
      _items
        ..clear()
        ..addAll(data);
    } catch (e) {
      _error = 'خطا در افزودن/حذف علاقه‌مندی: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
