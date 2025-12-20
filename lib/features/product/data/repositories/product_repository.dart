import 'package:flutter/material.dart';

import '../models/review_model.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../datasources/product_local_data_source.dart';

class ShopRepository extends ChangeNotifier {
  ShopRepository._();

  static final I = ShopRepository._();

  final ShopApi _api = ShopApi();
  final ShopStorage _storage = ShopStorage.I;

  List<ProductModel> _allProducts = [];
  List<CategoryModel> _categories = [];
  bool _categoriesLoaded = false;
  bool _isLoading = false;
  List<ProductModel> _products = [];

  String? _error;
  String? _selectedCategoryName;

  List<ProductModel> get allProducts => _allProducts;
  List<CategoryModel> get categories => _categories;
  bool get categoriesLoaded => _categoriesLoaded;
  String? get error => _error;
  bool get isLoading => _isLoading;
  List<ProductModel> get products => _products;
  String? get selectedCategoryName => _selectedCategoryName;

  Future<bool> addProductReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    try {
      final result = await _api.addProductReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );

      if (!result.success) {
        _error = result.error;
        notifyListeners();
        return false;
      }

      return true;
    } catch (e) {
      _error = 'ثبت دیدگاه ناموفق بود: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> filterProductsByCategory(String? categoryName) async {
    _selectedCategoryName = categoryName;

    if (categoryName == null) {
      await loadProducts();
    } else {
      await loadProducts(category: categoryName);
    }
  }

  Future<ProductModel?> getProduct(String id) async {
    try {
      final result = await _api.getProduct(id);
      return result.data;
    } catch (e) {
      return null;
    }
  }

  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      final result = await _api.getProductReviews(productId);

      if (!result.success) {
        _error = result.error;
        notifyListeners();
        return [];
      }

      return result.data ?? [];
    } catch (e) {
      _error = 'خطا در دریافت دیدگاه‌ها: $e';
      notifyListeners();
      return [];
    }
  }

  Future<void> loadAllProducts() async {
    if (_allProducts.isNotEmpty) return;

    try {
      final result = await _api.getProducts();
      if (result.success && result.data != null) {
        _allProducts = result.data!;
        notifyListeners();
      }
    } catch (e) {}
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
    int? priceMin,
    int? priceMax,
    int? rating,
    bool forceRefresh = false,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!forceRefresh &&
          category == null &&
          search == null &&
          priceMin == null &&
          priceMax == null &&
          rating == null) {
        final cachedProducts = await _storage.getCachedProducts();
        if (cachedProducts != null) {
          _products = cachedProducts;
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      final result = await _api.getProducts(
        search: search,
        category: category,
        ordering: ordering,
        priceMin: priceMin,
        priceMax: priceMax,
        rating: rating,
      );

      if (result.success && result.data != null) {
        _products = result.data!;

        if (category == null &&
            search == null &&
            priceMin == null &&
            priceMax == null &&
            rating == null) {
          _allProducts = List.from(_products);
          await _storage.cacheProducts(_products);
        }
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
    return searchProductsWithFilter(query: query);
  }

  Future<List<ProductModel>> searchProductsWithFilter({
    String? query,
    String? category,
    int? priceMin,
    int? priceMax,
    int? rating,
    String? ordering,
  }) async {
    try {
      final result = await _api.getProducts(
        search: query,
        category: category,
        priceMin: priceMin,
        priceMax: priceMax,
        rating: rating,
        ordering: ordering,
      );
      return result.data ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<ReviewModel?> toggleReviewLike({
    required String productId,
    required ReviewModel review,
  }) async {
    try {
      final result = await _api.toggleReviewLike(productId: productId, reviewId: review.id);

      if (!result.success) {
        _error = result.error;
        notifyListeners();
        return null;
      }

      return result.data;
    } catch (e) {
      _error = 'خطا در لایک/آن‌لایک دیدگاه: $e';
      notifyListeners();
      return null;
    }
  }
}
