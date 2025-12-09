class ProfileCompleteModels {
  ProfileCompleteModels({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirthJalali,
    required this.password,
    required this.gender,
    this.email,
    this.phoneNumber,
  });

  final String dateOfBirthJalali;
  final String? email;
  final String firstName;
  final String gender;
  final String lastName;
  final String password;
  final String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirthJalali,
      'password': password,
      'gender': gender,
    };
    if (email != null && email!.trim().isNotEmpty) map['email'] = email;
    if (phoneNumber != null && phoneNumber!.trim().isNotEmpty) map['phone_number'] = phoneNumber;
    return map;
  }
}
