import '../entities/category.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Category>> getCategories();

  Future<Product> getProductById(String id);

  Future<List<Product>> getProducts({
    String? categoryId,
    String? search,
    String? ordering,
    int? page,
    int? priceMin,
    int? priceMax,
    int? rating,
    bool forceRefresh = false,
  });
}
