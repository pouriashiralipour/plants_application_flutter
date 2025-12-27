import '../repositories/auth_repository.dart';

class RequestPasswordResetOtp {
  const RequestPasswordResetOtp(this._repo);

  final AuthRepository _repo;

  Future<void> call({required String target}) {
    return _repo.requestPasswordResetOtp(target: target);
  }
}
