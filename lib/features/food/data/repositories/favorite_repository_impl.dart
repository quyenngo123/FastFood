import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_data_source.dart';
import '../models/favorite_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FavoriteEntity>> getFavorites(String userId) async {
    return await remoteDataSource.getFavorites(userId);
  }

  @override
  Future<void> toggleFavorite(FavoriteEntity favorite, bool isAdd) async {
    await remoteDataSource.toggleFavorite(FavoriteModel.fromEntity(favorite), isAdd);
  }
}
