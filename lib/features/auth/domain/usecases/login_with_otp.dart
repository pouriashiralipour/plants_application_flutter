import '../../../profile/domain/entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class LoginWithOtp {
  const LoginWithOtp(this._repo);

  final AuthRepository _repo;

  Future<UserProfile> call({required String code}) async {
    final tokens = await _repo.verifyLoginOtp(code);
    await _repo.saveTokens(tokens);
    final user = await _repo.fetchCurrentUser();
    return user;
  }
}
