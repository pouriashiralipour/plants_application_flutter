import 'package:flutter/foundation.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/user_api.dart';
import '../models/auth_tokens_model.dart';
import '../../../profile/data/models/profile_models.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository._();

  static final I = AuthRepository._();

  UserProfile? _me;
  AuthTokens? _tokens;

  bool get isAuthed => _tokens != null;
  UserProfile? get me => _me;
  AuthTokens? get tokens => _tokens;

  Future<void> init() async {
    final (a, r) = await AuthStorage.I.readTokens();
    if (r != null) {
      final ok = await refreshWith(r);
      if (ok) return;
    }
    await logout(silent: true);
  }

  Future<void> loadMe() async {
    if (!isAuthed) return;
    final response = await UserApi().me();
    if (response.success && response.data != null) {
      _me = response.data;
    } else {
      _me = null;
    }
    notifyListeners();
  }

  Future<void> logout({bool silent = false}) async {
    _tokens = null;
    _me = null;
    await AuthStorage.I.clear();
    if (!silent) notifyListeners();
  }

  Future<bool> refreshIfPossible() async {
    final r = _tokens?.refresh ?? (await AuthStorage.I.readTokens()).$2;
    if (r == null) return false;
    return refreshWith(r);
  }

  Future<bool> refreshWith(String refreshToken) async {
    final res = await AuthApi().refresh(refreshToken);
    if (res.success && res.data != null) {
      final nt = AuthTokens(
        access: res.data!.tokens.access,
        refresh: res.data!.tokens.refresh.isNotEmpty ? res.data!.tokens.refresh : refreshToken,
      );
      await setTokens(nt);
      return true;
    }
    return false;
  }

  Future<void> setMe(UserProfile u) async {
    _me = u;
    notifyListeners();
  }

  Future<void> setTokens(AuthTokens tokens) async {
    _tokens = tokens;
    await AuthStorage.I.saveTokens(access: tokens.access, refresh: tokens.refresh);
    await loadMe();
    notifyListeners();
  }
}
