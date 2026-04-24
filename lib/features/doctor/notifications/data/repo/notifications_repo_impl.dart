import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:healing/core/constant/api_endpoint.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/network/error_handling.dart';
import 'package:healing/features/doctor/notifications/data/models/notification_model.dart';
import 'package:healing/features/doctor/notifications/domin/repo/notifications_repo.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final ApiService _api;

  NotificationsRepoImpl(this._api);

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    int pageIndex = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.notifications,
        queryParameters: {"pageIndex": pageIndex, "pageSize": pageSize},
      );
      final data = response.data["data"] ?? response.data;
      final list = (data as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final response = await _api.get(ApiEndpoints.unreadCount);
      return Right(response.data["count"] ?? 0);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String notificationId) async {
    try {
      await _api.put(ApiEndpoints.markRead(notificationId));
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      await _api.put(ApiEndpoints.readAll);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
