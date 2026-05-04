import '../../../appointment/domin/entity/appointment_entity.dart';
import '../entity/notification_display_item.dart';

/// Converts a list of AppointmentEntity into NotificationDisplayItem list.
/// Pure business logic — no UI, no API.
class BuildNotificationsFromAppointmentsUseCase {
  List<NotificationDisplayItem> call(List<AppointmentEntity> appointments) {
    final items = <NotificationDisplayItem>[];
    final now = DateTime.now();

    for (final apt in appointments) {
      final aptDate = DateTime.tryParse(apt.appointmentDate) ?? now;
      final isToday = aptDate.year == now.year &&
          aptDate.month == now.month &&
          aptDate.day == now.day;

      final timeAgo = _formatTimeAgo(aptDate, now);
      final startTime = apt.startTime.length >= 5
          ? apt.startTime.substring(0, 5)
          : apt.startTime;

      switch (apt.status.toLowerCase()) {
        case 'scheduled':
        case 'confirmed':
          items.add(NotificationDisplayItem(
            type: NotificationType.upcoming,
            title: 'Upcoming Appointment',
            body:
                'You have an appointment with Dr. ${apt.doctorName} on ${apt.appointmentDate} at $startTime.',
            timeAgo: timeAgo,
            isToday: isToday,
          ));
          break;
        case 'cancelled':
          items.add(NotificationDisplayItem(
            type: NotificationType.cancelled,
            title: 'Appointment Cancelled',
            body:
                'Your appointment with Dr. ${apt.doctorName} on ${apt.appointmentDate} has been cancelled.',
            timeAgo: timeAgo,
            isToday: isToday,
          ));
          break;
        case 'completed':
          items.add(NotificationDisplayItem(
            type: NotificationType.completed,
            title: 'Appointment Completed',
            body:
                'Your appointment with Dr. ${apt.doctorName} on ${apt.appointmentDate} has been completed.',
            timeAgo: timeAgo,
            isToday: isToday,
          ));
          break;
      }
    }

    return items;
  }

  String _formatTimeAgo(DateTime aptDate, DateTime now) {
    if (aptDate.isAfter(now)) {
      final d = aptDate.difference(now);
      if (d.inDays > 0) return 'in ${d.inDays}d';
      if (d.inHours > 0) return 'in ${d.inHours}h';
      return 'soon';
    }
    final diff = now.difference(aptDate);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}
