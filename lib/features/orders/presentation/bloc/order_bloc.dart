import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final GetOrdersUseCase _getOrdersUseCase;

  OrderBloc({
    required CreateOrderUseCase createOrderUseCase,
    required GetOrdersUseCase getOrdersUseCase,
  })  : _createOrderUseCase = createOrderUseCase,
        _getOrdersUseCase = getOrdersUseCase,
        super(OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<GetOrderHistoryEvent>(_onGetOrderHistory);
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await _createOrderUseCase(event.order);
      emit(OrderPlacedSuccess());
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _onGetOrderHistory(GetOrderHistoryEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _getOrdersUseCase(event.userId);
      emit(OrderSuccess(orders));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }
}
