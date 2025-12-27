import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class RefreshTokensIfNeeded {
  const RefreshTokensIfNeeded(this._repo);

  final AuthRepository _repo;

  Future<AuthTokens?> call() async {
    final tokens = await _repo.loadSavedTokens();
    if (tokens == null) {
      return null;
    }

    final refreshed = await _repo.refreshTokens(tokens.refresh);
    await _repo.saveTokens(refreshed);
    return refreshed;
  }
}
