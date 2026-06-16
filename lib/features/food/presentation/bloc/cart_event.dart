import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/voucher_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class WatchCartEvent extends CartEvent {
  final String userId;
  const WatchCartEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddToCartEvent extends CartEvent {
  final String userId;
  final CartItemEntity item;
  const AddToCartEvent({required this.userId, required this.item});

  @override
  List<Object?> get props => [userId, item];
}

class UpdateCartEvent extends CartEvent {
  final CartEntity cart;
  const UpdateCartEvent(this.cart);

  @override
  List<Object?> get props => [cart];
}

class ClearCartEvent extends CartEvent {
  final String userId;
  const ClearCartEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ApplyVoucherEvent extends CartEvent {
  final VoucherEntity voucher;
  const ApplyVoucherEvent(this.voucher);

  @override
  List<Object?> get props => [voucher];
}

class RemoveVoucherEvent extends CartEvent {}

class UpdateCartStateEvent extends CartEvent {
  final CartEntity? cart;
  const UpdateCartStateEvent(this.cart);

  @override
  List<Object?> get props => [cart];
}
