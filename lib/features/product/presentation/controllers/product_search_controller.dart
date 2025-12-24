import 'package:flutter/foundation.dart' hide Category;

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products.dart';

class ProductSearchController extends ChangeNotifier {
  ProductSearchController({
    required GetCategories getCategories,
    required GetProducts getProducts,
  }) : _getCategories = getCategories,
       _getProducts = getProducts;

  final List<Category> _categories = [];
  final GetCategories _getCategories;
  final GetProducts _getProducts;
  final List<Product> _products = [];

  bool _isLoading = false;

  String? _error;

  List<Category> get categories => List.unmodifiable(_categories);
  String? get error => _error;
  bool get isLoading => _isLoading;
  List<Product> get products => List.unmodifiable(_products);

  void clearResults() {
    _error = null;
    _products.clear();
    notifyListeners();
  }

  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) return;

    _setLoading(true);
    _error = null;

    try {
      final result = await _getCategories();
      _categories
        ..clear()
        ..addAll(result);
    } catch (e) {
      _error = 'خطا در دریافت دسته‌بندی‌ها: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> search({
    String? search,
    String? categoryName,
    String? ordering,
    int? page,
    int? priceMin,
    int? priceMax,
    int? rating,
    bool forceRefresh = true,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _getProducts(
        search: (search == null || search.trim().isEmpty)
            ? null
            : search.trim(),
        categoryId: (categoryName == null || categoryName.trim().isEmpty)
            ? null
            : categoryName.trim(),
        ordering: (ordering == null || ordering.trim().isEmpty)
            ? null
            : ordering.trim(),
        page: page,
        priceMin: priceMin,
        priceMax: priceMax,
        rating: rating,
        forceRefresh: forceRefresh,
      );

      _products
        ..clear()
        ..addAll(result);
    } catch (e) {
      _error = 'خطا در جستجو: $e';
      _products.clear();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
