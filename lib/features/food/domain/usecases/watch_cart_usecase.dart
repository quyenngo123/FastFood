import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class WatchCartUseCase {
  final CartRepository repository;

  WatchCartUseCase(this.repository);

  Stream<CartEntity?> call(String userId) {
    return repository.watchCart(userId);
  }
}
