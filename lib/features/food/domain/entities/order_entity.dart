import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

enum OrderStatus { pending, confirmed, processing, shipping, delivered, cancelled }

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<CartItemEntity> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String deliveryAddress;
  final String? phoneNumber;
  final String? paymentMethod;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    this.phoneNumber,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        totalAmount,
        status,
        createdAt,
        deliveryAddress,
        phoneNumber,
        paymentMethod,
      ];
}
