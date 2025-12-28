import '../../../profile/domain/entities/user_profile.dart' as domain_profile;
import '../../domain/entities/auth_tokens.dart' as domain_auth;
import '../../domain/repositories/auth_repository.dart' as domain_auth_repo;

import '../../../profile/data/models/profile_models.dart' as model_profile;
import '../models/auth_tokens_model.dart' as model_auth;
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/user_api.dart';

class AuthRepositoryImpl implements domain_auth_repo.AuthRepository {
  AuthRepositoryImpl({AuthApi? authApi, UserApi? userApi, AuthStorage? authStorage})
    : _authApi = authApi ?? AuthApi(),
      _userApi = userApi ?? UserApi(),
      _storage = authStorage ?? AuthStorage.I;

  final AuthApi _authApi;
  final AuthStorage _storage;
  final UserApi _userApi;

  @override
  Future<void> clearTokens() {
    return _storage.clear();
  }

  @override
  Future<domain_profile.UserProfile> fetchCurrentUser() async {
    final result = await _userApi.me();

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'دریافت پروفایل ناموفق بود');
    }

    final model_profile.UserProfile m = result.data!;
    return _mapProfileModelToDomain(m);
  }

  @override
  Future<domain_auth.AuthTokens?> loadSavedTokens() async {
    final (String? access, String? refresh) = await _storage.readTokens();

    if (access == null || refresh == null) {
      return null;
    }

    return domain_auth.AuthTokens(access: access, refresh: refresh);
  }

  @override
  Future<domain_auth.AuthTokens> loginWithPassword({
    required String login,
    required String password,
  }) async {
    final result = await _authApi.login(login: login, password: password);

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'ورود ناموفق بود');
    }

    final model_auth.AuthTokens tokens = result.data!.tokens;
    return domain_auth.AuthTokens(access: tokens.access, refresh: tokens.refresh);
  }

  @override
  Future<domain_auth.AuthTokens> refreshTokens(String refreshToken) async {
    final result = await _authApi.refresh(refreshToken);

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'نوسازی توکن ناموفق بود');
    }

    final model_auth.AuthTokens tokens = result.data!.tokens;
    return domain_auth.AuthTokens(access: tokens.access, refresh: tokens.refresh);
  }

  @override
  Future<void> requestOtp({required String target, required String purpose}) async {
    final result = await _authApi.requestOtp(target: target, purpose: purpose);
    if (!result.success) {
      throw Exception(result.error ?? 'ارسال کد ناموفق بود');
    }
  }

  @override
  Future<void> requestPasswordResetOtp({required String target}) async {
    final result = await _authApi.requestPasswordOtp(target: target);

    if (!result.success) {
      throw Exception(result.error ?? 'درخواست کد بازیابی رمز عبور ناموفق بود');
    }
  }

  @override
  Future<void> saveTokens(domain_auth.AuthTokens tokens) {
    return _storage.saveTokens(access: tokens.access, refresh: tokens.refresh);
  }

  @override
  Future<void> setNewPassword({
    required String resetToken,
    required String newPassword,
    String? confirmNewPassword,
  }) async {
    final result = await _authApi.setNewPassword(
      resetToken: resetToken,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );

    if (!result.success) {
      throw Exception(result.error ?? 'تنظیم رمز جدید ناموفق بود');
    }
  }

  @override
  Future<domain_auth.AuthTokens> verifyLoginOtp(String code) async {
    final result = await _authApi.verifyOtp(code);

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'تایید کد ناموفق بود');
    }

    final model_auth.AuthTokens tokens = result.data!.tokens;

    return domain_auth.AuthTokens(access: tokens.access, refresh: tokens.refresh);
  }

  @override
  Future<String> verifyPasswordResetOtp({required String code}) async {
    final result = await _authApi.verifyPasswordOtp(code: code);

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'کد بازیابی نامعتبر است');
    }

    final resetPayload = result.data!;
    final resetToken = resetPayload.resetToken;

    if (resetToken.isEmpty) {
      throw Exception('توکِن بازیابی از سرور دریافت نشد');
    }

    return resetToken;
  }

  domain_profile.UserProfile _mapProfileModelToDomain(model_profile.UserProfile m) {
    return domain_profile.UserProfile(
      userId: m.userId,
      email: m.email,
      gender: m.gender,
      fullName: m.fullName,
      phoneNumber: m.phoneNumber,
      firstName: m.firstName,
      lastName: m.lastName,
      birthDate: m.birthDate,
      profilePic: m.profilePic,
    );
  }
}
