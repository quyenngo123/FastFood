import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.imageUrl,
    super.title,
    super.subtitle,
    super.priority,
    super.price,
    super.linkAction,
    super.isActive = true,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    // Handle nested imageUrl map if it exists, otherwise use as string
    final imageUrlData = json['imageUrl'];
    String imgUrl = '';
    String? title;
    String? subtitle;
    int? priority;

    if (imageUrlData is Map<String, dynamic>) {
      imgUrl = imageUrlData['image'] as String? ?? '';
      title = imageUrlData['title'] as String?;
      subtitle = imageUrlData['subtitle'] as String?;
      priority = imageUrlData['priority'] as int?;
    } else {
      imgUrl = imageUrlData as String? ?? '';
    }

    return BannerModel(
      id: json['id'] as String? ?? '',
      imageUrl: imgUrl,
      title: title ?? json['title'] as String?,
      subtitle: subtitle ?? json['subtitle'] as String?,
      priority: priority ?? json['priority'] as int?,
      price: json['price'] as int?,
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
      'imageUrl': {
        'image': imageUrl,
        'title': title,
        'subtitle': subtitle,
        'priority': priority,
      },
      'price': price,
      'linkAction': linkAction,
      'isActive': isActive,
    };
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
    return BannerModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      title: entity.title,
      subtitle: entity.subtitle,
      priority: entity.priority,
      price: entity.price,
      linkAction: entity.linkAction,
      isActive: entity.isActive,
    );
  }
}
