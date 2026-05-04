/// Unified display model used by the UI — produced by the Cubit.
/// The UI only knows about this model, not about API responses or appointments.
enum NotificationType { upcoming, cancelled, completed }

class NotificationDisplayItem {
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final bool isToday;

  const NotificationDisplayItem({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    required this.isToday,
  });
}
