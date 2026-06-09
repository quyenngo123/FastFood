import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.userId,
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    required super.categoryId,
    required super.addedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      productImage: json['productImage'] as String? ?? '',
      productPrice: (json['productPrice'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] as String? ?? '',
      addedAt: json['addedAt'] is Timestamp 
          ? (json['addedAt'] as Timestamp).toDate() 
          : DateTime.tryParse(json['addedAt'].toString()) ?? DateTime.now(),
    );
  }

  factory FavoriteModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return FavoriteModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'categoryId': categoryId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      id: entity.id,
      userId: entity.userId,
      productId: entity.productId,
      productName: entity.productName,
      productImage: entity.productImage,
      productPrice: entity.productPrice,
      categoryId: entity.categoryId,
      addedAt: entity.addedAt,
    );
  }
}
