import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/no_param_use_case.dart';
import 'package:healing/features/doctor/notifications/data/models/notification_model.dart';
import 'package:healing/features/doctor/notifications/domin/repo/notifications_repo.dart';

class GetNotificationsUseCase implements UseCase<List<NotificationModel>> {
  final NotificationsRepo _repo;

  GetNotificationsUseCase(this._repo);

  @override
  Future<Either<Failure, List<NotificationModel>>> call() =>
      _repo.getNotifications();
}
