import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/watch_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

export 'notification_event.dart';
export 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final WatchNotificationsUseCase _watchNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;

  NotificationBloc({
    required WatchNotificationsUseCase watchNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
  })  : _watchNotificationsUseCase = watchNotificationsUseCase,
        _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
        super(NotificationInitial()) {
    on<WatchNotificationsEvent>(_onWatchNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<UpdateNotificationsStateEvent>(_onUpdateNotificationsState);
  }

  Future<void> _onWatchNotifications(
      WatchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    
    // emit.forEach tự động quản lý vòng đời của Stream (mở/đóng/hủy subscription cũ)
    await emit.forEach(
      _watchNotificationsUseCase(event.userId),
      onData: (notifications) {
        print('DEBUG_NOTI: Nhận ${notifications.length} thông báo từ Firestore cho UID: ${event.userId}');
        return NotificationLoaded(notifications);
      },
      onError: (error, stackTrace) {
        print('DEBUG_NOTI_ERROR: $error');
        return NotificationError(error.toString());
      },
    );
  }

  Future<void> _onMarkAsRead(
      MarkNotificationAsReadEvent event, Emitter<NotificationState> emit) async {
    try {
      await _markNotificationAsReadUseCase(event.notificationId);
      // Firestore Stream sẽ tự động đẩy dữ liệu mới về, không cần emit thủ công
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  void _onUpdateNotificationsState(
      UpdateNotificationsStateEvent event, Emitter<NotificationState> emit) {
    emit(NotificationLoaded(event.notifications));
  }
}
