import '../repositories/address_repository.dart';

class SetDefaultAddressUseCase {
  final AddressRepository repository;

  SetDefaultAddressUseCase(this.repository);

  Future<void> call(String userId, String addressId) async {
    await repository.setDefaultAddress(userId, addressId);
  }
}
