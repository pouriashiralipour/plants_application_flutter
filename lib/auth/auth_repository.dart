import 'package:flutter/foundation.dart';
import '../models/auth/auth_models.dart';
import 'auth_storage.dart';
import '../api/auth_api.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository._();

  static final I = AuthRepository._();

  AuthTokens? _tokens;

  bool get isAuthed => _tokens != null;
  AuthTokens? get tokens => _tokens;

  Future<void> init() async {
    final (a, r) = await AuthStorage.I.readTokens();
    if (r != null) {
      final ok = await refreshWith(r);
      if (ok) return;
    }
    await logout(silent: true);
  }

  Future<void> logout({bool silent = false}) async {
    _tokens = null;
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

  Future<void> setTokens(AuthTokens tokens) async {
    _tokens = tokens;
    await AuthStorage.I.saveTokens(access: tokens.access, refresh: tokens.refresh);
    notifyListeners();
  }
}
