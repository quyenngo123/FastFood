import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';
import 'voucher_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.userId,
    required super.items,
    super.appliedVoucher,
    required super.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      appliedVoucher: json['appliedVoucher'] != null 
          ? VoucherModel.fromJson(json['appliedVoucher'] as Map<String, dynamic>)
          : null,
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
      'appliedVoucher': appliedVoucher != null 
          ? VoucherModel.fromEntity(appliedVoucher!).toJson() 
          : null,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      userId: entity.userId,
      items: entity.items,
      appliedVoucher: entity.appliedVoucher,
      updatedAt: entity.updatedAt,
    );
  }
}
