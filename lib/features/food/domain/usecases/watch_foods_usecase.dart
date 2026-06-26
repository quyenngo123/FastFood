import '../entities/food_entity.dart';
import '../repositories/food_repository.dart';

class WatchFoodsUseCase {
  final FoodRepository repository;

  WatchFoodsUseCase(this.repository);

  Stream<List<FoodEntity>> call() {
    return repository.watchFoods();
  }
}
