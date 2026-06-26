import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/watch_foods_usecase.dart';
import 'food_event.dart';
import 'food_state.dart';

export 'food_event.dart';
export 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final WatchFoodsUseCase _watchFoodsUseCase;

  FoodBloc({required WatchFoodsUseCase watchFoodsUseCase})
      : _watchFoodsUseCase = watchFoodsUseCase,
        super(FoodInitial()) {
    on<WatchFoodsEvent>(_onWatchFoods);
    on<UpdateFoodsEvent>(_onUpdateFoods);
  }

  Future<void> _onWatchFoods(WatchFoodsEvent event, Emitter<FoodState> emit) async {
    emit(FoodLoading());
    print('DEBUG: Bắt đầu lắng nghe Stream từ Firestore...');
    
    // Sử dụng emit.forEach để tự động cập nhật State mỗi khi Firestore thay đổi
    await emit.forEach(
      _watchFoodsUseCase(),
      onData: (foods) {
        print('DEBUG: Đã nhận ${foods.length} món ăn từ Firestore');
        return FoodLoaded(foods);
      },
      onError: (error, stackTrace) {
        print('DEBUG: Lỗi Stream Firestore: $error');
        return FoodError(error.toString());
      },
    );
  }

  void _onUpdateFoods(UpdateFoodsEvent event, Emitter<FoodState> emit) {
    emit(FoodLoaded(event.foods));
  }
}
