import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository extends ChangeNotifier {
  ThemeRepository._();
  static final ThemeRepository I = ThemeRepository._();

  static const _k = 'is_dark';
  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    _isDark = sp.getBool(_k) ?? false;
  }

  Future<void> setDark(bool v) async {
    _isDark = v;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_k, v);
    notifyListeners();
  }

  Future<void> toggle() => setDark(!_isDark);
}
