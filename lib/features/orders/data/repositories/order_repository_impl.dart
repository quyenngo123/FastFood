import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createOrder(OrderEntity order) async {
    final orderModel = OrderModel(
      id: order.id,
      userId: order.userId,
      items: order.items,
      subtotal: order.subtotal,
      discountAmount: order.discountAmount,
      totalAmount: order.totalAmount,
      voucherCode: order.voucherCode,
      status: order.status,
      address: order.address,
      phone: order.phone,
      createdAt: order.createdAt,
    );
    await remoteDataSource.createOrder(orderModel);
  }

  @override
  Future<List<OrderEntity>> getOrders(String userId) async {
    return await remoteDataSource.getOrders(userId);
  }
}
