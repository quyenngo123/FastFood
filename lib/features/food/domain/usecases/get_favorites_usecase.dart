import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<FavoriteEntity>> call(String userId) async {
    return await repository.getFavorites(userId);
  }
}
