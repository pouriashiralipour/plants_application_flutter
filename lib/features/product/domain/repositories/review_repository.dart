import '../entities/review.dart';

abstract class ReviewRepository {
  Future<void> addProductReview({
    required String productId,
    required int rating,
    String? comment,
  });

  Future<List<Review>> getProductReviews(String productId);

  Future<Review> toggleReviewLike({
    required String productId,
    required String reviewId,
  });
}
