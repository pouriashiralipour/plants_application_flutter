import '../entities/category.dart';
import '../repositories/product_repository.dart';

class GetCategories {
  final ProductRepository _repo;

  const GetCategories(this._repo);

  Future<List<Category>> call() {
    return _repo.getCategories();
  }
}
