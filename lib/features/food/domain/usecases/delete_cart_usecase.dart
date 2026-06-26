import '../repositories/cart_repository.dart';

class DeleteCartUseCase {
  final CartRepository repository;

  DeleteCartUseCase(this.repository);

  Future<void> call(String userId) async {
    await repository.deleteCart(userId);
  }
}
