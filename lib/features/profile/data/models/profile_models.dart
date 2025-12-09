class UserProfile {
  UserProfile({
    required this.birthDate,
    required this.email,
    required this.gender,
    required this.full_name,
    required this.phone_number,
    required this.profilePic,
    required this.userId,
  });

  factory UserProfile.fromJson(Map json) => UserProfile(
    email: json['email'] as String? ?? '',
    gender: json['gender'] as String? ?? '',
    full_name: json['full_name'] as String? ?? '',
    phone_number: json['phone_number'] as String? ?? '',
    userId: json['id'] as String,
    birthDate: json['jalali_date_of_birth'] as String? ?? '',
    profilePic: json['profile_pic'] as String? ?? '',
  );

  final String birthDate;
  final String email;
  final String full_name;
  final String gender;
  final String phone_number;
  final String profilePic;
  final String userId;
}
