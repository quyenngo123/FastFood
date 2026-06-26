import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/notification_bloc.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thông báo', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationItem(notification: notification);
              },
            );
          }

          if (state is NotificationError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, 
            size: 80, color: Colors.grey.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('Bạn chưa có thông báo nào', 
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final dynamic notification;
  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationBloc>().add(MarkNotificationAsReadEvent(notification.id));
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getIconColor(notification.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(notification.type),
                color: _getIconColor(notification.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm').format(notification.createdAt),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'order': return Icons.local_shipping_rounded;
      case 'promo': return Icons.local_offer_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(String? type) {
    switch (type) {
      case 'order': return Colors.blue;
      case 'promo': return Colors.orange;
      default: return AppColors.primary;
    }
  }
}
