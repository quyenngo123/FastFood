import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String category;
  final bool isPopular;
  final bool isPromo;
  final double? originalPrice;

  const FoodEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.category,
    this.isPopular = false,
    this.isPromo = false,
    this.originalPrice,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        rating,
        reviewCount,
        imageUrl,
        category,
        isPopular,
        isPromo,
        originalPrice,
      ];
}
