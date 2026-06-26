import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateCartUseCase {
  final CartRepository repository;

  UpdateCartUseCase(this.repository);

  Future<void> call(CartEntity cart) async {
    await repository.updateCart(cart);
  }
}
