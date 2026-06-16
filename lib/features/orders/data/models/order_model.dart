import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';
import '../../../food/data/models/cart_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    required super.userId,
    required super.items,
    required super.subtotal,
    required super.discountAmount,
    required super.totalAmount,
    super.voucherCode,
    required super.status,
    required super.address,
    required super.phone,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      userId: json['userId'] ?? '',
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? (json['totalAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      voucherCode: json['voucherCode'] as String?,
      status: json['status'] ?? 'pending',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => CartItemModel.fromEntity(item).toJson()).toList(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'voucherCode': voucherCode,
      'status': status,
      'address': address,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
