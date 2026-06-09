import 'package:equatable/equatable.dart';

class ComboEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final double originalPrice;
  final double comboPrice;
  final int discountPercent;
  final bool isActive;
  final bool isBestSeller;
  final bool isNew;
  final List<ComboItemEntity> items;

  const ComboEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.originalPrice,
    required this.comboPrice,
    required this.discountPercent,
    required this.isActive,
    required this.isBestSeller,
    required this.isNew,
    required this.items,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        originalPrice,
        comboPrice,
        discountPercent,
        isActive,
        isBestSeller,
        isNew,
        items,
      ];
}

class ComboItemEntity extends Equatable {
  final String productId;
  final String productName;
  final int quantity;

  const ComboItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, productName, quantity];
}
