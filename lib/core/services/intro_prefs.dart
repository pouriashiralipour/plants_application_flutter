import 'package:shared_preferences/shared_preferences.dart';

class IntroPrefs {
  static const _kIntroDone = 'intro_done';

  static Future<bool> isIntroDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIntroDone) ?? false;
  }

  static Future<void> setIntroDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIntroDone, true);
  }
}
