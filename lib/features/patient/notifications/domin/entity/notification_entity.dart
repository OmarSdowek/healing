class NotificationEntity {
  final int id;
  final String title;
  final String message;
  final String type; // PaymentReceived, AppointmentReminder, AppointmentCancelled, etc.
  final String channel; // Push, Email, SMS
  final String deliveryStatus; // Sent, Delivered, Skipped, Failed
  final bool isRead;
  final String createdAt;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.channel,
    required this.deliveryStatus,
    required this.isRead,
    required this.createdAt,
  });
}
