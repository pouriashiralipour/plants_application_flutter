import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSource {
  CartLocalDataSource({SharedPreferences? prefs}) : _prefs = prefs;

  final SharedPreferences? _prefs;

  static const _cartIdKey = 'cart_id';

  Future<String?> readCartId() async {
    final sp = _prefs ?? await SharedPreferences.getInstance();
    final id = sp.getString(_cartIdKey);
    if (id == null) return null;

    final trimmed = id.trim();
    if (trimmed.isEmpty) return null;

    return trimmed;
  }

  Future<void> saveCartId(String id) async {
    final sp = _prefs ?? await SharedPreferences.getInstance();
    await sp.setString(_cartIdKey, id.trim());
  }

  Future<void> clearCartId() async {
    final sp = _prefs ?? await SharedPreferences.getInstance();
    await sp.remove(_cartIdKey);
  }
}
