import '../../../profile/domain/entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class LoadSavedSession {
  const LoadSavedSession(this._repo);

  final AuthRepository _repo;

  Future<UserProfile?> call() async {
    final tokens = await _repo.loadSavedTokens();
    if (tokens == null) {
      return null;
    }

    final user = await _repo.fetchCurrentUser();
    return user;
  }
}
