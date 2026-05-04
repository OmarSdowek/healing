import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domin/entity/notification_entity.dart';
import '../../domin/repo/notification_repo.dart';
import '../model/notification_model.dart';

class NotificationRepoImpl implements NotificationRepo {
  final ApiService api;
  NotificationRepoImpl(this.api);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final response = await api.get(
        ApiEndpoints.getNotifications,
        queryParameters: {'PageIndex': 1, 'PageSize': 50},
      );
      return Right(_parse(response.data));
    } on DioException catch (e) {
      print("❌ getNotifications: ${e.response?.statusCode}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>>
      getUnreadNotifications() async {
    try {
      final response = await api.get(ApiEndpoints.getUnreadNotifications);
      return Right(_parse(response.data));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final response = await api.get(ApiEndpoints.getUnreadCount);
      final count = (response.data['count'] as num?)?.toInt() ??
          (response.data as num?)?.toInt() ??
          0;
      return Right(count);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int id) async {
    try {
      await api.put(ApiEndpoints.markNotificationRead(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await api.put(ApiEndpoints.markAllRead);
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  List<NotificationEntity> _parse(dynamic raw) {
    List<dynamic> data;
    if (raw is Map) {
      data = (raw['data'] ?? raw['items'] ?? []) as List;
    } else if (raw is List) {
      data = raw;
    } else {
      data = [];
    }
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
