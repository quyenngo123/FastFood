import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class WatchNotificationsUseCase {
  final NotificationRepository repository;

  WatchNotificationsUseCase(this.repository);

  Stream<List<NotificationEntity>> call(String userId) {
    return repository.watchNotifications(userId);
  }
}
