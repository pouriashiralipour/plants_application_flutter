import '../repositories/auth_repository.dart';

class Logout {
  const Logout(this._repo);

  final AuthRepository _repo;

  Future<void> call() async {
    await _repo.clearTokens();
  }
}
