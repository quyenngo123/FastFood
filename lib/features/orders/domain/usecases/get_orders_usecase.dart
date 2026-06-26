import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call(String userId) async {
    return await repository.getOrders(userId);
  }
}
