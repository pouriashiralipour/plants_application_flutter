import '../entities/address.dart';
import '../repositories/address_repository.dart';

class AddAddress {
  const AddAddress(this._repo);

  final AddressRepository _repo;

  Future<Address> call({
    required String name,
    required String address,
    String? postalCode,
    bool isDefault = false,
  }) {
    return _repo.addAddress(
      name: name,
      address: address,
      postalCode: postalCode,
      isDefault: isDefault,
    );
  }
}
