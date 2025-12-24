import '../entities/review.dart';
import '../repositories/review_repository.dart';

class ToggleReviewLike {
  const ToggleReviewLike(this._repo);

  final ReviewRepository _repo;

  Future<Review> call({required String productId, required String reviewId}) {
    return _repo.toggleReviewLike(productId: productId, reviewId: reviewId);
  }
}
