import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/watch_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/update_cart_usecase.dart';
import '../../domain/usecases/delete_cart_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

export 'cart_event.dart';
export 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final UpdateCartUseCase _updateCartUseCase;
  final DeleteCartUseCase _deleteCartUseCase;

  CartBloc({
    required GetCartUseCase getCartUseCase,
    required UpdateCartUseCase updateCartUseCase,
    required DeleteCartUseCase deleteCartUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _updateCartUseCase = updateCartUseCase,
        _deleteCartUseCase = deleteCartUseCase,
        super(CartInitial()) {
    on<WatchCartEvent>(_onWatchCart);
    on<UpdateCartEvent>(_onUpdateCart);
    on<ClearCartEvent>(_onClearCart);
    on<UpdateCartStateEvent>(_onUpdateCartState);
    on<AddToCartEvent>(_onAddToCart);
    on<ApplyVoucherEvent>(_onApplyVoucher);
    on<RemoveVoucherEvent>(_onRemoveVoucher);
  }

  Future<void> _onWatchCart(WatchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await _getCartUseCase(event.userId);
      emit(CartLoaded(cart));
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  Future<void> _onUpdateCart(UpdateCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoaded(event.cart));
      await _updateCartUseCase(event.cart);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      CartEntity? currentCart;
      if (state is CartLoaded) {
        currentCart = (state as CartLoaded).cart;
      } else {
        currentCart = await _getCartUseCase(event.userId);
      }

      List<CartItemEntity> items = currentCart != null ? List.from(currentCart.items) : [];
      final index = items.indexWhere((i) => i.productId == event.item.productId);

      if (index != -1) {
        items[index] = items[index].copyWith(
          quantity: items[index].quantity + event.item.quantity,
        );
      } else {
        items.add(event.item);
      }

      final updatedCart = CartEntity(
        userId: event.userId,
        items: items,
        appliedVoucher: currentCart?.appliedVoucher,
        updatedAt: DateTime.now(),
      );

      emit(CartLoaded(updatedCart));
      await _updateCartUseCase(updatedCart);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onApplyVoucher(ApplyVoucherEvent event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      if (currentCart != null) {
        final updatedCart = currentCart.copyWith(appliedVoucher: event.voucher);
        emit(CartLoaded(updatedCart));
        await _updateCartUseCase(updatedCart);
      }
    }
  }

  Future<void> _onRemoveVoucher(RemoveVoucherEvent event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      if (currentCart != null) {
        final updatedCart = currentCart.copyWith(clearVoucher: true);
        emit(CartLoaded(updatedCart));
        await _updateCartUseCase(updatedCart);
      }
    }
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    try {
      await _deleteCartUseCase(event.userId);
      emit(const CartLoaded(null));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onUpdateCartState(UpdateCartStateEvent event, Emitter<CartState> emit) {
    emit(CartLoaded(event.cart));
  }
}
