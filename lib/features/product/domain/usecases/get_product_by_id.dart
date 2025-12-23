import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductById {
  const GetProductById(this._repo);

  final ProductRepository _repo;

  Future<Product> call(String id) {
    return _repo.getProductById(id);
  }
}
