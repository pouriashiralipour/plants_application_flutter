import '../../../profile/domain/entities/user_profile.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class LoginWithPassword {
  const LoginWithPassword(this._repo);

  final AuthRepository _repo;

  Future<UserProfile> call({required String login, required String password}) async {
    final AuthTokens tokens = await _repo.loginWithPassword(login: login, password: password);

    await _repo.saveTokens(tokens);

    final user = await _repo.fetchCurrentUser();
    return user;
  }
}
