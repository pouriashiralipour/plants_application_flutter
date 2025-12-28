import '../entities/auth_tokens.dart';
import '../../../profile/domain/entities/user_profile.dart';

abstract class AuthRepository {
  Future<void> clearTokens();

  Future<UserProfile> fetchCurrentUser();

  Future<AuthTokens?> loadSavedTokens();

  Future<AuthTokens> loginWithPassword({required String login, required String password});

  Future<AuthTokens> refreshTokens(String refreshToken);

  Future<void> requestPasswordResetOtp({required String target});

  Future<void> saveTokens(AuthTokens tokens);

  Future<void> requestOtp({required String target, required String purpose});

  Future<void> setNewPassword({
    required String resetToken,
    required String newPassword,
    String? confirmNewPassword,
  });

  Future<AuthTokens> verifyLoginOtp(String code);

  Future<String> verifyPasswordResetOtp({required String code});
}
