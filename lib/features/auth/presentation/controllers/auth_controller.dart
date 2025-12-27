import 'package:flutter/foundation.dart';

import '../../../profile/domain/entities/user_profile.dart';

import '../../domain/usecases/login_with_password.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/load_saved_session.dart';
import '../../domain/usecases/refresh_tokens_if_needed.dart';
import '../../domain/usecases/get_current_user.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required LoginWithPassword loginWithPassword,
    required Logout logout,
    required LoadSavedSession loadSavedSession,
    required RefreshTokensIfNeeded refreshTokensIfNeeded,
    required GetCurrentUser getCurrentUser,
  }) : _loginWithPassword = loginWithPassword,
       _logoutUseCase = logout,
       _loadSavedSession = loadSavedSession,
       _refreshTokensIfNeeded = refreshTokensIfNeeded,
       _getCurrentUser = getCurrentUser;

  final GetCurrentUser _getCurrentUser;
  final LoadSavedSession _loadSavedSession;
  final LoginWithPassword _loginWithPassword;
  final Logout _logoutUseCase;
  final RefreshTokensIfNeeded _refreshTokensIfNeeded;

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
      _error = 'خطا در ورود: $e';
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

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }
}
