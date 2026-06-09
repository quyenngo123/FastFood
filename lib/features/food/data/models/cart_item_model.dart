import '../../domain/entities/cart_item_entity.dart';
import 'food_model.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.food,
    required super.quantity,
    super.note,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String? ?? '',
      food: FoodModel.fromJson(json['food'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': FoodModel.fromEntity(food).toJson(),
      'quantity': quantity,
      'note': note,
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      food: entity.food,
      quantity: entity.quantity,
      note: entity.note,
    );
  }
}
