import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/combo_entity.dart';

class ComboModel extends ComboEntity {
  const ComboModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.originalPrice,
    required super.comboPrice,
    required super.discountPercent,
    required super.isActive,
    required super.isBestSeller,
    required super.isNew,
    required super.items,
  });

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    return ComboModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      comboPrice: (json['comboPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercent: json['discountPercent'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isBestSeller: json['isBestSeller'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ComboItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory ComboModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ComboModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'originalPrice': originalPrice,
      'comboPrice': comboPrice,
      'discountPercent': discountPercent,
      'isActive': isActive,
      'isBestSeller': isBestSeller,
      'isNew': isNew,
      'items': items.map((item) => ComboItemModel.fromEntity(item).toJson()).toList(),
    };
  }

  factory ComboModel.fromEntity(ComboEntity entity) {
    return ComboModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      image: entity.image,
      originalPrice: entity.originalPrice,
      comboPrice: entity.comboPrice,
      discountPercent: entity.discountPercent,
      isActive: entity.isActive,
      isBestSeller: entity.isBestSeller,
      isNew: entity.isNew,
      items: entity.items,
    );
  }
}

class ComboItemModel extends ComboItemEntity {
  const ComboItemModel({
    required super.productId,
    required super.productName,
    required super.quantity,
  });

  factory ComboItemModel.fromJson(Map<String, dynamic> json) {
    return ComboItemModel(
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
    };
  }

  factory ComboItemModel.fromEntity(ComboItemEntity entity) {
    return ComboItemModel(
      productId: entity.productId,
      productName: entity.productName,
      quantity: entity.quantity,
    );
  }
}
