import '../entities/cart_entity.dart';

abstract class CartRepository {
  Stream<CartEntity?> watchCart(String userId);
  Future<CartEntity?> getCart(String userId);
  Future<void> updateCart(CartEntity cart);
  Future<void> deleteCart(String userId);
}
