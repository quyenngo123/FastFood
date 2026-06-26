import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class ToggleFavoriteUseCase {
  final FavoriteRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(FavoriteEntity favorite, bool isAdd) async {
    await repository.toggleFavorite(favorite, isAdd);
  }
}
