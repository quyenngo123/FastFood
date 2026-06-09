import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? type; // 'order', 'promo', etc.

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.type,
  });

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead, type];
}
