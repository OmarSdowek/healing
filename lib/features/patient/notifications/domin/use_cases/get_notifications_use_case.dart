import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/notification_entity.dart';
import '../repo/notification_repo.dart';

class GetNotificationsUseCase {
  final NotificationRepo repo;
  GetNotificationsUseCase(this.repo);

  Future<Either<Failure, List<NotificationEntity>>> call() =>
      repo.getNotifications();
}
