import '../../domain/entities/address_entity.dart';

abstract class AddressRepository {
  Future<List<AddressEntity>> getAddresses(String userId);
  Future<void> saveAddress(AddressEntity address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String userId, String addressId);
}
