import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AddressEntity>> getAddresses(String userId) async {
    return await remoteDataSource.getAddresses(userId);
  }

  @override
  Future<void> saveAddress(AddressEntity address) async {
    await remoteDataSource.saveAddress(AddressModel.fromEntity(address));
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await remoteDataSource.deleteAddress(addressId);
  }

  @override
  Future<void> setDefaultAddress(String userId, String addressId) async {
    await remoteDataSource.setDefaultAddress(userId, addressId);
  }
}
