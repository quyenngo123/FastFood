import '../../domain/entities/food_entity.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/food_remote_data_source.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodRemoteDataSource remoteDataSource;

  FoodRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<FoodEntity>> watchFoods() {
    return remoteDataSource.watchFoods();
  }

  @override
  Future<List<FoodEntity>> getFoods() async {
    return await remoteDataSource.getFoods();
  }

  @override
  Future<List<String>> getCategories() async {
    return await remoteDataSource.getCategories();
  }
}
