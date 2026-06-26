import '../entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getFavorites(String userId);
  Future<void> toggleFavorite(FavoriteEntity favorite, bool isAdd);
}
