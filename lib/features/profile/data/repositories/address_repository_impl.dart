import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';
import '../mappers/address_model_mapper.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl({AddressApi? api}) : _api = api ?? AddressApi();

  final AddressApi _api;

  @override
  Future<Address> addAddress({
    required String name,
    required String address,
    String? postalCode,
    bool isDefault = false,
  }) async {
    final draft = AddressModel(
      id: '',
      name: name,
      address: address,
      postalCode: postalCode,
      isDefault: isDefault,
    );

    final res = await _api.create(draft);
    if (!res.success || res.data == null) {
      throw Exception(res.error ?? 'خطا در ثبت آدرس');
    }
    return res.data!.toEntity();
  }

  @override
  Future<void> deleteAddress({required String id}) {
    throw UnimplementedError('حذف آدرس در API فعلی پیاده‌سازی نشده است');
  }

  @override
  Future<List<Address>> getAddresses() async {
    final res = await _api.list();
    if (!res.success || res.data == null) {
      throw Exception(res.error ?? 'خطا در دریافت آدرس‌ها');
    }
    return res.data!.map((e) => e.toEntity()).toList();
  }
}
