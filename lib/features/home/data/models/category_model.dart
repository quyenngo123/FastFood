import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../food/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.image,
    super.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CategoryModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      isActive: entity.isActive,
    );
  }
}
