import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../mappers/category_model_mapper.dart';
import '../mappers/product_model_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({ShopApi? api, ShopStorage? storage})
    : _api = api ?? ShopApi(),
      _storage = storage ?? ShopStorage.I;

  final ShopApi _api;
  final ShopStorage _storage;

  @override
  Future<List<Category>> getCategories() async {
    final cached = await _storage.getCachedCategories();
    if (cached != null) {
      return cached.map((m) => m.toEntity()).toList();
    }

    final result = await _api.getCategories();
    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در دریافت دسته‌بندی‌ها');
    }

    await _storage.cacheCategories(result.data!);
    return result.data!.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final result = await _api.getProduct(id);
    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در دریافت محصول');
    }

    return result.data!.toEntity();
  }

  @override
  Future<List<Product>> getProducts({
    String? categoryId,
    String? search,
    String? ordering,
    int? page,
    int? priceMin,
    int? priceMax,
    int? rating,
    bool forceRefresh = false,
  }) async {
    final bool isDefaultQuery =
        (categoryId == null || categoryId.isEmpty) &&
        (search == null || search.isEmpty) &&
        (ordering == null || ordering.isEmpty) &&
        page == null &&
        priceMin == null &&
        priceMax == null &&
        rating == null;

    if (!forceRefresh && isDefaultQuery) {
      final cached = await _storage.getCachedProducts();
      if (cached != null) {
        return cached.map((m) => m.toEntity()).toList();
      }
    }

    final result = await _api.getProducts(
      search: search,
      category: categoryId,
      ordering: ordering,
      page: page,
      priceMin: priceMin,
      priceMax: priceMax,
      rating: rating,
    );

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در دریافت محصولات');
    }

    if (!forceRefresh && isDefaultQuery) {
      await _storage.cacheProducts(result.data!);
    }

    return result.data!.map((m) => m.toEntity()).toList();
  }
}
