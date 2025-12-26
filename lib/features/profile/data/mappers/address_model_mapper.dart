import '../../domain/entities/address.dart';
import '../models/address_model.dart';

extension AddressModelMapper on AddressModel {
  Address toEntity() {
    return Address(
      id: id,
      name: name,
      address: address,
      postalCode: postalCode,
      isDefault: isDefault,
    );
  }
}

extension AddressEntityMapper on Address {
  AddressModel toModel() {
    return AddressModel(
      id: id,
      name: name,
      address: address,
      postalCode: postalCode,
      isDefault: isDefault,
    );
  }
}
