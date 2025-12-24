import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repo);

  final ProductRepository _repo;

  Future<List<Product>> call({
    String? categoryId,
    String? search,
    String? ordering,
    int? page,
    int? priceMin,
    int? priceMax,
    int? rating,
    bool forceRefresh = false,
  }) {
    return _repo.getProducts(
      categoryId: categoryId,
      search: search,
      ordering: ordering,
      page: page,
      priceMin: priceMin,
      priceMax: priceMax,
      rating: rating,
      forceRefresh: forceRefresh,
    );
  }
}
