import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../mappers/review_model_mapper.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({ShopApi? api}) : _api = api ?? ShopApi();

  final ShopApi _api;

  @override
  Future<List<Review>> getProductReviews(String productId) async {
    final result = await _api.getProductReviews(productId);

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در دریافت دیدگاه‌ها');
    }

    return result.data!.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Review> toggleReviewLike({
    required String productId,
    required String reviewId,
  }) async {
    final result = await _api.toggleReviewLike(
      productId: productId,
      reviewId: reviewId,
    );

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در لایک/آن‌لایک دیدگاه');
    }

    return result.data!.toEntity();
  }

  @override
  Future<void> addProductReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    final result = await _api.addProductReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    if (!result.success) {
      throw Exception(result.error ?? 'خطا در ثبت دیدگاه');
    }
  }
}
