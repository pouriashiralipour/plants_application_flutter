import '../entities/review.dart';
import '../repositories/review_repository.dart';

class GetProductReviews {
  const GetProductReviews(this._repo);

  final ReviewRepository _repo;

  Future<List<Review>> call(String productId) {
    return _repo.getProductReviews(productId);
  }
}
