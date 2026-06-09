import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.rating,
    required super.reviewCount,
    required super.imageUrl,
    required super.category,
    super.isPopular = false,
    super.isPromo = false,
    super.originalPrice,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      isPopular: json['isPopular'] as bool? ?? false,
      isPromo: json['isPromo'] as bool? ?? false,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
    );
  }

  factory FoodModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return FoodModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'category': category,
      'isPopular': isPopular,
      'isPromo': isPromo,
      'originalPrice': originalPrice,
    };
  }

  factory FoodModel.fromEntity(FoodEntity entity) {
    return FoodModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      imageUrl: entity.imageUrl,
      category: entity.category,
      isPopular: entity.isPopular,
      isPromo: entity.isPromo,
      originalPrice: entity.originalPrice,
    );
  }
}
