import '../entities/food_entity.dart';

abstract class FoodRepository {
  Stream<List<FoodEntity>> watchFoods();
  Future<List<FoodEntity>> getFoods();
  Future<List<String>> getCategories();
}
