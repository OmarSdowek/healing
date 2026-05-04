import '../../domin/entity/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.channel,
    required super.deliveryStatus,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['notificationType']?.toString() ??
          json['type']?.toString() ?? '',
      channel: json['channel']?.toString() ?? 'Push',
      deliveryStatus: json['deliveryStatus']?.toString() ?? '',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt']?.toString() ??
          json['sentAt']?.toString() ?? '',
    );
  }
}
