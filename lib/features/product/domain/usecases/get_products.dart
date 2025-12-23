import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repo);

  final ProductRepository _repo;

  Future<List<Product>> call({String? categoryId, String? search, int? page}) {
    return _repo.getProducts(
      categoryId: categoryId,
      search: search,
      page: page,
    );
  }
}
