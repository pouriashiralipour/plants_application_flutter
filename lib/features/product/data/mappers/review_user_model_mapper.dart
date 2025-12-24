import '../../domain/entities/review_user.dart';
import '../models/review_model.dart';

extension ReviewUserModelMapper on ReviewUserModel {
  ReviewUser toEntity() {
    return ReviewUser(id: id, fullName: fullName, profilePic: profilePic);
  }
}
