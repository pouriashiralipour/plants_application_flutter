import '../repositories/auth_repository.dart';

class SetNewPassword {
  const SetNewPassword(this._repo);

  final AuthRepository _repo;

  Future<void> call({
    required String resetToken,
    required String newPassword,
    String? confirmNewPassword,
  }) {
    return _repo.setNewPassword(
      resetToken: resetToken,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
