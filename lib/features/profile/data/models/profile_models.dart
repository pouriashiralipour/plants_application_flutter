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
    required this.lastName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] as String? ?? '';
    final fullName = json['full_name'] as String? ?? '';
    final lastNameJson = json['last_name'] as String? ?? '';

    return UserProfile(
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      firstName: firstName,
      lastName: lastNameJson.isNotEmpty
          ? lastNameJson
          : _deriveLastName(fullName: fullName, firstName: firstName),
      fullName: fullName,
      phoneNumber: json['phone_number'] as String? ?? '',
      userId: json['id'] as String,
      birthDate: json['date_of_birth'] as String?,
      profilePic: json['profile_pic'] as String?,
    );
  }

  static String _deriveLastName({required String fullName, required String firstName}) {
    final fn = firstName.trim();
    final full = fullName.trim();
    if (full.isEmpty) return '';

    if (fn.isNotEmpty && full.startsWith(fn)) {
      return full.substring(fn.length).trim();
    }

    final parts = full.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length <= 1) return '';
    return parts.sublist(1).join(' ');
  }

  final String? birthDate;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String gender;
  final String phoneNumber;
  final String? profilePic;
  final String userId;
}
