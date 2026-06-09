import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.userId,
    required super.items,
    required super.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now(),
    );
  }

  factory CartModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CartModel.fromJson({
      ...data,
      'userId': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => CartItemModel.fromEntity(item).toJson()).toList(),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      userId: entity.userId,
      items: entity.items,
      updatedAt: entity.updatedAt,
    );
  }
}
