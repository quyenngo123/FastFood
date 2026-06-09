import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String userId;
  final List<CartItemEntity> items;
  final DateTime updatedAt;

  const CartEntity({
    required this.userId,
    required this.items,
    required this.updatedAt,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [userId, items, updatedAt];
}
