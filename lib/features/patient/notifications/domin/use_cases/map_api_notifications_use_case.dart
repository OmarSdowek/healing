import '../entity/notification_display_item.dart';
import '../entity/notification_entity.dart';

/// Maps raw API NotificationEntity list → NotificationDisplayItem list.
/// All type-mapping and time-formatting logic lives here.
class MapApiNotificationsUseCase {
  List<NotificationDisplayItem> call(List<NotificationEntity> notifications) {
    return notifications.map((n) {
      final type = _mapType(n.type);
      final timeAgo = _formatTimeAgo(n.createdAt);
      final isToday = _isToday(n.createdAt);

      return NotificationDisplayItem(
        title: n.title.isNotEmpty ? n.title : _defaultTitle(type),
        body: n.message,
        timeAgo: timeAgo,
        type: type,
        isToday: isToday,
      );
    }).toList();
  }

  NotificationType _mapType(String type) {
    final t = type.toLowerCase();
    if (t.contains('cancel')) return NotificationType.cancelled;
    if (t.contains('complet')) return NotificationType.completed;
    return NotificationType.upcoming;
  }

  String _defaultTitle(NotificationType type) {
    switch (type) {
      case NotificationType.cancelled:
        return 'Appointment Cancelled';
      case NotificationType.completed:
        return 'Appointment Completed';
      case NotificationType.upcoming:
        return 'Upcoming Appointment';
    }
  }

  String _formatTimeAgo(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      return 'just now';
    } catch (_) {
      return '';
    }
  }

  bool _isToday(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    } catch (_) {
      return false;
    }
  }
}
