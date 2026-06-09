import 'package:equatable/equatable.dart';
import 'food_entity.dart';

class CartItemEntity extends Equatable {
  final String id;
  final FoodEntity food;
  final int quantity;
  final String? note;

  const CartItemEntity({
    required this.id,
    required this.food,
    required this.quantity,
    this.note,
  });

  double get totalPrice => food.price * quantity;

  CartItemEntity copyWith({
    int? quantity,
    String? note,
  }) {
    return CartItemEntity(
      id: id,
      food: food,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, food, quantity, note];
}
