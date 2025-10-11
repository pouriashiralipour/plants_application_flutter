import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/store/category_model.dart';
import '../models/store/product_model.dart';

class ShopStorage {
  ShopStorage._();

  static final I = ShopStorage._();

  final _cacheDuration = const Duration(hours: 1);
  final _categoriesKey = 'cached_categories';
  final _productsKey = 'cached_products';
  final _storage = const FlutterSecureStorage();

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final data = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'categories': categories.map((c) => c.toJson()).toList(),
    };
    await _storage.write(key: _categoriesKey, value: json.encode(data));
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    final data = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'products': products.map((p) => p.toJson()).toList(),
    };
    await _storage.write(key: _productsKey, value: json.encode(data));
  }

  Future<void> clearCache() async {
    await _storage.delete(key: _productsKey);
    await _storage.delete(key: _categoriesKey);
  }

  Future<List<CategoryModel>?> getCachedCategories() async {
    final cached = await _storage.read(key: _categoriesKey);
    if (cached == null) return null;

    try {
      final data = json.decode(cached) as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - timestamp > _cacheDuration.inMilliseconds) {
        await _storage.delete(key: _categoriesKey);
        return null;
      }

      final categories = (data['categories'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return categories;
    } catch (e) {
      await _storage.delete(key: _categoriesKey);
      return null;
    }
  }

  Future<List<ProductModel>?> getCachedProducts() async {
    final cached = await _storage.read(key: _productsKey);
    if (cached == null) return null;

    try {
      final data = json.decode(cached) as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - timestamp > _cacheDuration.inMilliseconds) {
        await _storage.delete(key: _productsKey);
        return null;
      }

      final products = (data['products'] as List).map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (e) {
      await _storage.delete(key: _productsKey);
      return null;
    }
  }
}
