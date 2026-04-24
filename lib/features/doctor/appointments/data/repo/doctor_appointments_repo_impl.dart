import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:healing/core/constant/api_endpoint.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/network/error_handling.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/domin/repo/doctor_appointments_repo.dart';

class DoctorAppointmentsRepoImpl implements DoctorAppointmentsRepo {
  final ApiService _api;

  DoctorAppointmentsRepoImpl(this._api);

  @override
  Future<Either<Failure, List<AppointmentModel>>> getDoctorAppointments({
    required int doctorId,
    String? date,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.doctorAppointments(doctorId),
        queryParameters: date != null ? {"date": date} : null,
      );
      final list = (response.data as List)
          .map((e) => AppointmentModel.fromJson(e))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointmentById(int id) async {
    try {
      final response = await _api.get(ApiEndpoints.appointmentById(id));
      return Right(AppointmentModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> confirmAppointment(int id) async {
    try {
      final response = await _api.put(ApiEndpoints.confirmAppointment(id));
      return Right(AppointmentModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> completeAppointment({
    required int id,
    String? notes,
  }) async {
    try {
      final response = await _api.put(
        ApiEndpoints.completeAppointment(id),
        queryParameters: notes != null ? {"notes": notes} : null,
      );
      return Right(AppointmentModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAppointment({
    required int id,
    required String reason,
  }) async {
    try {
      await _api.put(
        ApiEndpoints.cancelAppointment(id),
        queryParameters: {"reason": reason},
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> markNoShow(int id) async {
    try {
      await _api.put(ApiEndpoints.noShowAppointment(id));
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
