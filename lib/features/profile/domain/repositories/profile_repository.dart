import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<UserProfile> updateProfile({
    String? firstName,
    String? lastName,
    String? gender,
    String? birthDate,
    String? email,
    String? phoneNumber,
    String? profilePic,
  });
}
