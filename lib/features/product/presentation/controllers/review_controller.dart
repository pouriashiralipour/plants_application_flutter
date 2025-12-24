import 'package:flutter/foundation.dart';

import '../../domain/entities/review.dart';
import '../../domain/usecases/add_product_review.dart';
import '../../domain/usecases/get_product_reviews.dart';
import '../../domain/usecases/toggle_review_like.dart';

class ReviewController extends ChangeNotifier {
  ReviewController({
    required GetProductReviews getProductReviews,
    required ToggleReviewLike toggleReviewLike,
    required AddProductReview addProductReview,
  }) : _getProductReviews = getProductReviews,
       _toggleReviewLike = toggleReviewLike,
       _addProductReview = addProductReview;

  final AddProductReview _addProductReview;
  final GetProductReviews _getProductReviews;
  final List<Review> _reviews = [];
  final ToggleReviewLike _toggleReviewLike;

  bool _isLoading = false;

  String? _error;

  String? get error => _error;
  bool get isLoading => _isLoading;
  List<Review> get reviews => List.unmodifiable(_reviews);

  Future<void> addReview({required String productId, required int rating, String? comment}) async {
    _setLoading(true);
    _error = null;

    try {
      await _addProductReview(productId: productId, rating: rating, comment: comment);

      final result = await _getProductReviews(productId);
      _reviews
        ..clear()
        ..addAll(result);
    } catch (e) {
      _error = 'خطا در ثبت دیدگاه: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> load(String productId) async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _getProductReviews(productId);
      _reviews
        ..clear()
        ..addAll(result);
    } catch (e) {
      _error = 'خطا در دریافت دیدگاه‌ها: $e';
      _reviews.clear();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleLike({required String productId, required String reviewId}) async {
    try {
      final updated = await _toggleReviewLike(productId: productId, reviewId: reviewId);

      final index = _reviews.indexWhere((r) => r.id == updated.id);
      if (index != -1) {
        _reviews[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = 'خطا در لایک/آن‌لایک: $e';
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
