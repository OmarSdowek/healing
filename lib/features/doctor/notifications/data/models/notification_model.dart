class NotificationModel {
  final String id;
  final String type;
  final String subject;
  final String body;
  final String? relatedEntityId;
  final String? relatedEntityType;
  final String createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.subject,
    required this.body,
    this.relatedEntityId,
    this.relatedEntityType,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"]?.toString() ?? "",
        type: json["notificationType"] ?? json["type"] ?? "",
        subject: json["subject"] ?? "",
        body: json["body"] ?? "",
        relatedEntityId: json["relatedEntityId"]?.toString(),
        relatedEntityType: json["relatedEntityType"],
        createdAt: json["createdAt"] ?? "",
        isRead: json["isRead"] ?? false,
      );
}
