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
    int? page,
  }) async {
    final bool isDefaultQuery =
        (categoryId == null || categoryId.isEmpty) &&
        (search == null || search.isEmpty) &&
        page == null;

    if (isDefaultQuery) {
      final cached = await _storage.getCachedProducts();
      if (cached != null) {
        return cached.map((m) => m.toEntity()).toList();
      }
    }

    final result = await _api.getProducts(
      search: search,
      category: categoryId,
      page: page,
    );

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در دریافت محصولات');
    }

    if (isDefaultQuery) {
      await _storage.cacheProducts(result.data!);
    }

    return result.data!.map((m) => m.toEntity()).toList();
  }
}
