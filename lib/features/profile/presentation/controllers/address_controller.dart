import 'package:flutter/foundation.dart';

import '../../domain/entities/address.dart';
import '../../domain/usecases/add_address.dart';
import '../../domain/usecases/get_addresses.dart';

class AddressController extends ChangeNotifier {
  AddressController({required GetAddresses getAddresses, required AddAddress addAddress})
    : _getAddresses = getAddresses,
      _addAddress = addAddress;

  final AddAddress _addAddress;
  final GetAddresses _getAddresses;
  final List<Address> _items = [];

  bool _isLoading = false;

  String? _error;

  String? get error => _error;
  bool get isLoading => _isLoading;
  List<Address> get items => List.unmodifiable(_items);

  Future<bool> add({
    required String name,
    required String address,
    String? postalCode,
    required bool isDefault,
  }) async {
    _error = null;
    notifyListeners();

    try {
      _setLoading(true);
      await _addAddress(name: name, address: address, postalCode: postalCode, isDefault: isDefault);
      await load();
      return true;
    } catch (e) {
      _error = 'ثبت آدرس ناموفق بود: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> load() async {
    _setLoading(true);
    _error = null;

    try {
      final data = await _getAddresses();
      _items
        ..clear()
        ..addAll(data);
    } catch (e) {
      _items.clear();
      _error = 'خطا در دریافت آدرس‌ها: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
