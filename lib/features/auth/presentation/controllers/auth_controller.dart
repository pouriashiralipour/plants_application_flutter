import 'package:flutter/foundation.dart';

import '../../../profile/domain/entities/user_profile.dart';

import '../../domain/usecases/login_with_password.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/load_saved_session.dart';
import '../../domain/usecases/refresh_tokens_if_needed.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_with_otp.dart';
import '../../domain/usecases/request_password_reset_otp.dart';
import '../../domain/usecases/verify_password_reset_otp.dart';
import '../../domain/usecases/set_new_password.dart';
import '../../domain/usecases/request_otp.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required LoginWithPassword loginWithPassword,
    required LoginWithOtp loginWithOtp,
    required Logout logout,
    required LoadSavedSession loadSavedSession,
    required RefreshTokensIfNeeded refreshTokensIfNeeded,
    required GetCurrentUser getCurrentUser,
    required RequestPasswordResetOtp requestPasswordResetOtp,
    required VerifyPasswordResetOtp verifyPasswordResetOtp,
    required SetNewPassword setNewPassword,
    required RequestOtp requestOtp,
  }) : _loginWithPassword = loginWithPassword,
       _loginWithOtp = loginWithOtp,
       _logoutUseCase = logout,
       _loadSavedSession = loadSavedSession,
       _refreshTokensIfNeeded = refreshTokensIfNeeded,
       _getCurrentUser = getCurrentUser,
       _requestPasswordResetOtp = requestPasswordResetOtp,
       _verifyPasswordResetOtp = verifyPasswordResetOtp,
       _setNewPassword = setNewPassword,
       _requestOtp = requestOtp;

  final GetCurrentUser _getCurrentUser;
  final LoadSavedSession _loadSavedSession;
  final LoginWithOtp _loginWithOtp;
  final LoginWithPassword _loginWithPassword;
  final Logout _logoutUseCase;
  final RefreshTokensIfNeeded _refreshTokensIfNeeded;
  final RequestOtp _requestOtp;
  final RequestPasswordResetOtp _requestPasswordResetOtp;
  final SetNewPassword _setNewPassword;
  final VerifyPasswordResetOtp _verifyPasswordResetOtp;

  bool _isLoading = false;

  String? _error;
  UserProfile? _user;

  String? get error => _error;
  bool get isAuthed => _user != null;
  bool get isLoading => _isLoading;
  UserProfile? get user => _user;

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  Future<void> init() async {
    _setLoading(true);
    _error = null;

    try {
      final sessionUser = await _loadSavedSession();
      _user = sessionUser;
    } catch (e) {
      _error = 'خطا در بازیابی سشن: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login({required String login, required String password}) async {
    _setLoading(true);
    _error = null;

    try {
      final loggedInUser = await _loginWithPassword(login: login, password: password);
      _user = loggedInUser;
    } catch (e) {
      final raw = e.toString();
      final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
      _error = cleaned.isEmpty ? 'ورود ناموفق بود' : 'خطا در ورود: $cleaned';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginWithOtp({required String code}) async {
    _setLoading(true);
    _error = null;

    try {
      final loggedInUser = await _loginWithOtp(code: code);
      _user = loggedInUser;
    } catch (e) {
      final raw = e.toString();
      final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
      _error = cleaned.isEmpty ? 'ورود با کد یکبارمصرف ناموفق بود' : 'خطا در ورود: $cleaned';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _error = null;

    try {
      await _logoutUseCase();
      _user = null;
    } catch (e) {
      _error = 'خطا در خروج: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshSessionIfNeeded() async {
    try {
      await _refreshTokensIfNeeded();
      if (_user == null) {
        _user = await _getCurrentUser();
      }
      notifyListeners();
    } catch (e) {
      _error = 'ناتوان در نوسازی سشن: $e';
      notifyListeners();
    }
  }

  Future<void> reloadProfile() async {
    _setLoading(true);

    try {
      _user = await _getCurrentUser();
      _error = null;
    } catch (e) {
      _error = 'خطا در دریافت پروفایل: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> requestOtp({required String target, required String purpose}) async {
    _setLoading(true);
    _error = null;

    try {
      await _requestOtp(target: target, purpose: purpose);
    } catch (e) {
      final raw = e.toString();
      final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
      _error = cleaned.isEmpty ? 'ارسال کد ناموفق بود' : cleaned;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> requestPasswordResetCode(String target) async {
    _setLoading(true);
    _error = null;

    try {
      await _requestPasswordResetOtp(target: target);
    } catch (e) {
      final raw = e.toString();
      final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
      _error = cleaned.isEmpty ? 'درخواست کد بازیابی ناموفق بود' : cleaned;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setNewPasswordWithToken({
    required String resetToken,
    required String newPassword,
    String? confirmNewPassword,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _setNewPassword(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
    } catch (e) {
      final raw = e.toString();
      final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
      _error = cleaned.isEmpty ? 'تنظیم رمز جدید ناموفق بود' : cleaned;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> verifyPasswordResetCode(String code) async {
    _setLoading(true);
    _error = null;

    try {
      final resetToken = await _verifyPasswordResetOtp(code: code);
      return resetToken;
    } catch (e) {
      final raw = e.toString();
      final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
      _error = cleaned.isEmpty ? 'کد بازیابی نامعتبر است' : cleaned;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }
}
