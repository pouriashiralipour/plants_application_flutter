import '../repositories/review_repository.dart';

class AddProductReview {
  const AddProductReview(this._repo);

  final ReviewRepository _repo;

  Future<void> call({
    required String productId,
    required int rating,
    String? comment,
  }) {
    return _repo.addProductReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}
