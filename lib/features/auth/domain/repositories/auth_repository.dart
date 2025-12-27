import '../entities/auth_tokens.dart';
import '../../../profile/domain/entities/user_profile.dart';

abstract class AuthRepository {
  Future<void> clearTokens();

  Future<UserProfile> fetchCurrentUser();

  Future<AuthTokens?> loadSavedTokens();

  Future<AuthTokens> loginWithPassword({required String login, required String password});

  Future<AuthTokens> refreshTokens(String refreshToken);
  Future<AuthTokens> verifyLoginOtp(String code);

  Future<void> saveTokens(AuthTokens tokens);
}
