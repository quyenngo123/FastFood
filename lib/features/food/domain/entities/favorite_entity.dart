import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final String categoryId;
  final DateTime addedAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.categoryId,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        productId,
        productName,
        productImage,
        productPrice,
        categoryId,
        addedAt,
      ];
}
