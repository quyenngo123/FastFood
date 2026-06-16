import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';
import 'voucher_entity.dart';

class CartEntity extends Equatable {
  final String userId;
  final List<CartItemEntity> items;
  final VoucherEntity? appliedVoucher;
  final DateTime updatedAt;

  const CartEntity({
    required this.userId,
    required this.items,
    this.appliedVoucher,
    required this.updatedAt,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  
  double get discountAmount {
    if (appliedVoucher == null) return 0;
    if (subtotal < appliedVoucher!.minOrderAmount) return 0;
    return appliedVoucher!.discountAmount;
  }

  double get totalAmount => subtotal - discountAmount;
  
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartEntity copyWith({
    String? userId,
    List<CartItemEntity>? items,
    VoucherEntity? appliedVoucher,
    bool clearVoucher = false,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      appliedVoucher: clearVoucher ? null : (appliedVoucher ?? this.appliedVoucher),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [userId, items, appliedVoucher, updatedAt];
}
