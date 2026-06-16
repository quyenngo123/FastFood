import 'package:equatable/equatable.dart';
import '../../../food/domain/entities/cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String? id;
  final String userId;
  final List<CartItemEntity> items;
  final num subtotal;
  final double discountAmount;
  final double totalAmount;
  final String? voucherCode;
  final String status;
  final String address;
  final String phone;
  final DateTime createdAt;

  const OrderEntity({
    this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.totalAmount,
    this.voucherCode,
    required this.status,
    required this.address,
    required this.phone,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        subtotal,
        discountAmount,
        totalAmount,
        voucherCode,
        status,
        address,
        phone,
        createdAt
      ];
}
