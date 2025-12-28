import '../repositories/auth_repository.dart';

class RequestOtp {
  const RequestOtp(this._repo);

  final AuthRepository _repo;

  Future<void> call({required String target, required String purpose}) {
    return _repo.requestOtp(target: target, purpose: purpose);
  }
}
