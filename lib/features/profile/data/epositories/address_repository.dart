import 'package:flutter/foundation.dart';
import '../datasources/address_remote_data_source.dart';
import '../models/address_model.dart';

class AddressRepository extends ChangeNotifier {
  AddressRepository._();

  static final I = AddressRepository._();

  final AddressApi _api = AddressApi();

  bool _isLoading = false;
  List<AddressModel> _items = [];

  String? _error;

  String? get error => _error;
  bool get isLoading => _isLoading;
  List<AddressModel> get items => _items;

  Future<bool> add({
    required String name,
    required String address,
    String? postalCode,
    required bool isDefault,
  }) async {
    _error = null;
    notifyListeners();

    final draft = AddressModel(
      id: '',
      name: name,
      address: address,
      postalCode: postalCode,
      isDefault: isDefault,
    );

    final res = await _api.create(draft);
    if (res.success && res.data != null) {
      await load();
      return true;
    }

    _error = res.error ?? 'ثبت آدرس ناموفق بود';
    notifyListeners();
    return false;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await _api.list();
    if (res.success && res.data != null) {
      _items = res.data!;
    } else {
      _error = res.error ?? 'خطا در دریافت آدرس‌ها';
    }

    _isLoading = false;
    notifyListeners();
  }
}
