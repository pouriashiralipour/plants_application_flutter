import '../entities/address.dart';

abstract class AddressRepository {
  Future<Address> addAddress({
    required String name,
    required String address,
    String? postalCode,
    bool isDefault = false,
  });

  Future<void> deleteAddress({required String id});

  Future<List<Address>> getAddress();
}
