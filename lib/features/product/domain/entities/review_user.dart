class ReviewUser {
  const ReviewUser({required this.id, required this.fullName, this.profilePic});

  final String id;
  final String fullName;
  final String? profilePic;

  @override
  String toString() {
    return 'ReviewUser(id: $id, fullName: $fullName, profilePic: $profilePic)';
  }
}
