import '../../domain/entities/review.dart';
import '../models/review_model.dart';
import 'review_user_model_mapper.dart';

extension ReviewModelMapper on ReviewModel {
  Review toEntity() {
    return Review(
      id: id,
      user: user.toEntity(),
      rating: rating,
      comment: comment,
      likesCount: likesCount,
      createdAt: createdAt,
      isLikedByMe: isLikedByMe,
    );
  }
}
