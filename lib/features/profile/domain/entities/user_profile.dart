class UserProfile {
  const UserProfile({
    required this.userId,
    required this.email,
    required this.gender,
    required this.fullName,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.profilePic,
  });

  final String userId;
  final String email;
  final String gender;
  final String fullName;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final String? profilePic;
}
