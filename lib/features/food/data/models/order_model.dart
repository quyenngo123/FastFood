import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';
import 'cart_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    required super.deliveryAddress,
    super.phoneNumber,
    super.paymentMethod,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => OrderStatus.pending,
      ),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now(),
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => CartItemModel.fromEntity(item).toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'deliveryAddress': deliveryAddress,
      'phoneNumber': phoneNumber,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      items: entity.items,
      totalAmount: entity.totalAmount,
      status: entity.status,
      createdAt: entity.createdAt,
      deliveryAddress: entity.deliveryAddress,
      phoneNumber: entity.phoneNumber,
      paymentMethod: entity.paymentMethod,
    );
  }
}
