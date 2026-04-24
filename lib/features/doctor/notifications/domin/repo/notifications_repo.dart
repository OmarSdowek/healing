import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/features/doctor/notifications/data/models/notification_model.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    int pageIndex,
    int pageSize,
  });
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, Unit>> markAsRead(String notificationId);
  Future<Either<Failure, Unit>> markAllAsRead();
}
