import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userImageUrl,
    required super.foodId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userImageUrl: json['userImageUrl'] as String? ?? '',
      foodId: json['foodId'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate() 
          : DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now(),
    );
  }

  factory ReviewModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ReviewModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'foodId': foodId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userImageUrl: entity.userImageUrl,
      foodId: entity.foodId,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
    );
  }
}
