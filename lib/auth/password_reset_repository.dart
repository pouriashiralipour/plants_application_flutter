import 'package:flutter/foundation.dart';

class PasswordResetRepository extends ChangeNotifier {
  String? _resetToken;

  bool get hasToken => _resetToken != null;
  String? get resetToken => _resetToken;

  Future<void> clear() async {
    _resetToken = null;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _resetToken = token;
    notifyListeners();
  }
}
