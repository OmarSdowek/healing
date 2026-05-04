part of 'notification_cubit.dart';

/// Groups notifications into today / earlier sections
class NotificationGroups {
  final List<NotificationDisplayItem> today;
  final List<NotificationDisplayItem> earlier;

  const NotificationGroups({
    required this.today,
    required this.earlier,
  });

  bool get isEmpty => today.isEmpty && earlier.isEmpty;
}

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final NotificationGroups groups;
  NotificationsLoaded(this.groups);
}

class NotificationEmpty extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
