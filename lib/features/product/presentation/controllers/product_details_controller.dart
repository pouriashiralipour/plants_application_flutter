import 'package:flutter/foundation.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_by_id.dart';

class ProductDetailsController extends ChangeNotifier {
  ProductDetailsController({required GetProductById getProductById})
    : _getProductById = getProductById;

  final GetProductById _getProductById;

  bool _isLoading = false;

  String? _error;
  Product? _product;

  String? get error => _error;
  bool get isLoading => _isLoading;
  Product? get product => _product;

  void clear() {
    _error = null;
    _product = null;
    notifyListeners();
  }

  Future<void> load(String productId) async {
    _setLoading(true);
    _error = null;

    try {
      _product = await _getProductById(productId);
    } catch (e) {
      _error = 'خطا در دریافت اطلاعات محصول: $e';
      _product = null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
