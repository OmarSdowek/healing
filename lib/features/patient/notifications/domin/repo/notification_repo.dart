import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/notification_entity.dart';

abstract class NotificationRepo {
  /// GET /api/notifications
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  /// GET /api/notifications/unread
  Future<Either<Failure, List<NotificationEntity>>> getUnreadNotifications();

  /// GET /api/notifications/unread/count
  Future<Either<Failure, int>> getUnreadCount();

  /// PUT /api/notifications/{id}/read
  Future<Either<Failure, void>> markAsRead(int id);

  /// PUT /api/notifications/read-all
  Future<Either<Failure, void>> markAllAsRead();
}
