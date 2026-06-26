import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return remoteDataSource.watchNotifications(userId);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await remoteDataSource.markAsRead(notificationId);
  }
}
