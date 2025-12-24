import 'package:flutter/foundation.dart' hide Category;

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/get_products.dart';

class ProductController extends ChangeNotifier {
  ProductController({
    required GetCategories getCategories,
    required GetProducts getProducts,
    required GetProductById getProductById,
  }) : _getCategories = getCategories,
       _getProducts = getProducts,
       _getProductById = getProductById;

  final List<Product> _allProducts = [];
  final List<Category> _categories = [];
  final GetCategories _getCategories;
  final GetProductById _getProductById;
  final GetProducts _getProducts;
  final List<Product> _products = [];

  bool _categoriesLoaded = false;
  bool _isLoading = false;

  String? _error;
  String? _selectedCategoryName;

  List<Product> get allProducts => List.unmodifiable(_allProducts);
  List<Category> get categories => List.unmodifiable(_categories);
  bool get categoriesLoaded => _categoriesLoaded;
  String? get error => _error;
  bool get isLoading => _isLoading;
  List<Product> get products => List.unmodifiable(_products);
  String? get selectedCategoryName => _selectedCategoryName;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> filterProductsByCategory(String? categoryName) async {
    _selectedCategoryName = categoryName;
    notifyListeners();

    await loadProducts(categoryName: categoryName);
  }

  Future<Product?> getProductById(String id) async {
    try {
      return await _getProductById(id);
    } catch (e) {
      _error = 'خطا در دریافت محصول: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> loadCategories() async {
    if (_categoriesLoaded && _categories.isNotEmpty) return;

    _setLoading(true);
    _error = null;

    try {
      final result = await _getCategories();
      _categories
        ..clear()
        ..addAll(result);
      _categoriesLoaded = true;
    } catch (e) {
      _error = 'خطا در دریافت دسته‌بندی‌ها: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProducts({
    String? search,
    String? categoryName,
    String? ordering,
    int? page,
    int? priceMin,
    int? priceMax,
    int? rating,
    bool forceRefresh = false,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    _error = null;

    try {
      final result = await _getProducts(
        search: search,
        categoryId: categoryName,
        ordering: ordering,
        page: page,
        priceMin: priceMin,
        priceMax: priceMax,
        rating: rating,
        forceRefresh: forceRefresh,
      );

      _products
        ..clear()
        ..addAll(result);

      final bool isDefaultQuery =
          (search == null || search.trim().isEmpty) &&
          (categoryName == null || categoryName.trim().isEmpty) &&
          (ordering == null || ordering.trim().isEmpty) &&
          page == null &&
          priceMin == null &&
          priceMax == null &&
          rating == null &&
          !forceRefresh;

      if (isDefaultQuery) {
        _allProducts
          ..clear()
          ..addAll(result);
      }
    } catch (e) {
      _error = 'خطا در دریافت محصولات: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshAll() async {
    _categoriesLoaded = false;
    _categories.clear();
    _allProducts.clear();
    _products.clear();
    notifyListeners();

    await loadCategories();
    await loadProducts();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
