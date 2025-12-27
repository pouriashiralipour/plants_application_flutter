import '../repositories/auth_repository.dart';

class VerifyPasswordResetOtp {
  const VerifyPasswordResetOtp(this._repo);

  final AuthRepository _repo;

  Future<String> call({required String code}) {
    return _repo.verifyPasswordResetOtp(code: code);
  }
}
