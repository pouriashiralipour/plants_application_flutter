import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository extends ChangeNotifier {
  ThemeRepository._();
  static final ThemeRepository I = ThemeRepository._();

  static const _k = 'is_dark';

  bool? _isDark;

  bool get isDark {
    if (_isDark != null) {
      return _isDark!;
    }
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  ThemeMode get themeMode {
    if (_isDark == null) {
      return ThemeMode.system;
    }
    return _isDark! ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    if (sp.containsKey(_k)) {
      _isDark = sp.getBool(_k);
    } else {
      _isDark = null;
    }
  }

  Future<void> setDark(bool v) async {
    _isDark = v;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_k, v);
    notifyListeners();
  }

  Future<void> clearPreference() async {
    _isDark = null;
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_k);
    notifyListeners();
  }

  Future<void> toggle() async => setDark(!isDark);
}
