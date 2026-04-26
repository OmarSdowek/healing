import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/network/token_storage.dart';
import '../../domain/entities/doctor_schedule_entity.dart';
import '../../domain/repositories/doctor_schedule_repository.dart';
import '../models/doctor_schedule_model.dart';

class DoctorScheduleRepositoryImpl implements DoctorScheduleRepository {
  final ApiService _api;

  DoctorScheduleRepositoryImpl(this._api);

  Future<String?> _getDoctorId() async {
    var doctorId = await TokenStorage.getDoctorId();

    if (doctorId == null) {
      try {
        final token = await TokenStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          final parts = token.split('.');
          if (parts.length == 3) {
            final decoded = utf8.decode(
              base64Url.decode(base64Url.normalize(parts[1])),
            );
            final payload = jsonDecode(decoded);
            doctorId = payload['doctor_id']?.toString();

            if (doctorId != null) {
              await TokenStorage.saveDoctorId(doctorId);
            }
          }
        }
      } catch (e) {
        // If JWT parsing fails, continue
      }
    }

    return doctorId;
  }

  @override
  Future<Either<Failure, List<DoctorScheduleEntity>>> getSchedules() async {
    try {
      final doctorId = await _getDoctorId();
      if (doctorId == null) {
        return Left(Failure('Doctor ID not found'));
      }

      final response = await _api.get(
        ApiEndpoints.doctorSchedules(int.parse(doctorId)),
      );

      final schedules = (response.data as List)
          .map((e) => DoctorScheduleModel.fromJson(e))
          .toList();

      return Right(schedules);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorScheduleEntity>> updateSchedule(
    int scheduleId,
    DoctorScheduleEntity schedule,
  ) async {
    try {
      final model = DoctorScheduleModel(
        id: schedule.id,
        doctorId: schedule.doctorId,
        dayOfWeek: schedule.dayOfWeek,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        isActive: schedule.isActive,
      );

      final response = await _api.put(
        '${ApiEndpoints.doctorSchedules(schedule.doctorId ?? 0)}/$scheduleId',
        data: model.toJson(),
      );

      final updatedSchedule = DoctorScheduleModel.fromJson(response.data);
      return Right(updatedSchedule);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
