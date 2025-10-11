import 'package:flutter/foundation.dart';

import '../api/shop_api.dart';
import '../models/store/category_model.dart';
import '../models/store/product_model.dart';
import 'shop_storage.dart';

class ShopRepository extends ChangeNotifier {
  ShopRepository._();

  static final I = ShopRepository._();

  final ShopApi _api = ShopApi();
  final ShopStorage _storage = ShopStorage.I;

  List<CategoryModel> _categories = [];
  bool _categoriesLoaded = false;
  bool _isLoading = false;
  List<ProductModel> _products = [];

  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get categoriesLoaded => _categoriesLoaded;
  String? get error => _error;
  bool get isLoading => _isLoading;
  List<ProductModel> get products => _products;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<ProductModel?> getProduct(String id) async {
    try {
      final result = await _api.getProduct(id);
      return result.data;
    } catch (e) {
      return null;
    }
  }

  Future<void> loadCategories({bool forceRefresh = false}) async {
    if (_categoriesLoaded && _categories.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!forceRefresh) {
        final cachedCategories = await _storage.getCachedCategories();
        if (cachedCategories != null) {
          _categories = cachedCategories;
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      final result = await _api.getCategories();

      if (result.success && result.data != null) {
        _categories = result.data!;
        _categoriesLoaded = true;
        await _storage.cacheCategories(_categories);
      } else {
        _error = result.error;
      }
    } catch (e) {
      _error = 'خطا در دریافت دسته‌بندی‌ها: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts({
    String? search,
    String? category,
    String? ordering,
    bool forceRefresh = false,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!forceRefresh) {
        final cachedProducts = await _storage.getCachedProducts();
        if (cachedProducts != null) {
          _products = cachedProducts;
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      final result = await _api.getProducts(search: search, category: category, ordering: ordering);

      if (result.success && result.data != null) {
        _products = result.data!;
        await _storage.cacheProducts(_products);
      } else {
        _error = result.error;
      }
    } catch (e) {
      _error = 'خطا در دریافت محصولات: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    await loadProducts(forceRefresh: true);
    await loadCategories(forceRefresh: true);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final result = await _api.getProducts(search: query);
      return result.data ?? [];
    } catch (e) {
      return [];
    }
  }
}
