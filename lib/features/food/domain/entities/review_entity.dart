import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String foodId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.foodId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userImageUrl,
        foodId,
        rating,
        comment,
        createdAt,
      ];
}
