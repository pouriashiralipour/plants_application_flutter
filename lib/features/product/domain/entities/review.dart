import 'review_user.dart';

class Review {
  const Review({
    required this.id,
    required this.user,
    required this.rating,
    this.comment,
    required this.likesCount,
    required this.createdAt,
    required this.isLikedByMe,
  });

  final String id;
  final ReviewUser user;
  final int rating;
  final String? comment;
  final int likesCount;
  final DateTime createdAt;
  final bool isLikedByMe;

  @override
  String toString() {
    return 'Review(id: $id, user: $user, rating: $rating, comment: $comment, likesCount: $likesCount, createdAt: $createdAt, isLikedByMe: $isLikedByMe)';
  }
}
