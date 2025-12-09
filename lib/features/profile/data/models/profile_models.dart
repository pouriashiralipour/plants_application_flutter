class UserProfile {
  UserProfile({
    required this.birthDate,
    required this.email,
    required this.gender,
    required this.fullName,
    required this.phoneNumber,
    required this.profilePic,
    required this.userId,
    required this.firstName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    email: json['email'] as String? ?? '',
    gender: json['gender'] as String? ?? '',
    firstName: json['first_name'] as String? ?? '',
    fullName: json['full_name'] as String? ?? '',
    phoneNumber: json['phone_number'] as String? ?? '',
    userId: json['id'] as String,
    birthDate: json['date_of_birth'] as String?,
    profilePic: json['profile_pic'] as String?,
  );

  final String? birthDate;
  final String email;
  final String firstName;
  final String fullName;
  final String gender;
  final String phoneNumber;
  final String? profilePic;
  final String userId;
}
