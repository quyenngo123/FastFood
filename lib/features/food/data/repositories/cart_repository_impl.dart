import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<CartEntity?> watchCart(String userId) {
    return remoteDataSource.watchCart(userId);
  }

  @override
  Future<CartEntity?> getCart(String userId) async {
    return await remoteDataSource.getCart(userId);
  }

  @override
  Future<void> updateCart(CartEntity cart) async {
    await remoteDataSource.updateCart(CartModel.fromEntity(cart));
  }

  @override
  Future<void> deleteCart(String userId) async {
    await remoteDataSource.deleteCart(userId);
  }
}
