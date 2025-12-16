import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';

class ReviewUserModel {
  const ReviewUserModel({required this.id, required this.fullName, this.profilePic});

  final String id;
  final String fullName;
  final String? profilePic;

  factory ReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ReviewUserModel(
      id: json['id']?.toString() ?? '',
      fullName: (json['full_name'] ?? '').toString(),
      profilePic: json['profile_pic'] as String?,
    );
  }
}

class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.likesCount,
    required this.createdAt,
    this.isLikedByMe = false,
  });

  final String id;
  final ReviewUserModel user;
  final int rating;
  final String? comment;
  final int likesCount;
  final DateTime createdAt;
  final bool isLikedByMe;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      user: ReviewUserModel.fromJson(json['user'] as Map<String, dynamic>),
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment']?.toString(),
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      isLikedByMe: (json['is_liked_by_me'] as bool?) ?? (json['is_liked'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': {'id': user.id, 'full_name': user.fullName, 'profile_pic': user.profilePic},
      'rating': rating,
      'comment': comment,
      'likes_count': likesCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get formattedDate {
    return '${createdAt.year}/${createdAt.month}/${createdAt.day}'.farsiNumber;
  }
}
