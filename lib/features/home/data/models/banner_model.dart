import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.imageUrl,
    super.linkAction,
    super.isActive = true,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      linkAction: json['linkAction'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BannerModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'linkAction': linkAction,
      'isActive': isActive,
    };
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
    return BannerModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      linkAction: entity.linkAction,
      isActive: entity.isActive,
    );
  }
}
