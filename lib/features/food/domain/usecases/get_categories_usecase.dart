import '../repositories/food_repository.dart';

class GetCategoriesUseCase {
  final FoodRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getCategories();
  }
}
