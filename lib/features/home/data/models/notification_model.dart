import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead = false,
    super.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate() 
          : DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      type: json['type'] as String?,
    );
  }

  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return NotificationModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'type': type,
    };
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      createdAt: entity.createdAt,
      isRead: entity.isRead,
      type: entity.type,
    );
  }
}
