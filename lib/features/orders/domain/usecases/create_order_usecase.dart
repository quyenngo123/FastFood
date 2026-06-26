import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<void> call(OrderEntity order) async {
    await repository.createOrder(order);
  }
}
