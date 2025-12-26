import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetAddresses {
  const GetAddresses(this._repo);

  final AddressRepository _repo;

  Future<List<Address>> call() {
    return _repo.getAddresses();
  }
}
