import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domain/repositories/doctor_appointment_action_repo.dart';

class DoctorAppointmentActionRepoImpl implements DoctorAppointmentActionRepo {
  final ApiService api;
  DoctorAppointmentActionRepoImpl(this.api);

  @override
  Future<Either<Failure, void>> confirmAppointment(int id) async {
    try {
      await api.put(ApiEndpoints.confirmAppointment(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, void>> completeAppointment(int id,
      {String? notes}) async {
    try {
      await api.put(
        ApiEndpoints.completeAppointment(id),
        queryParameters: notes != null && notes.isNotEmpty
            ? {'notes': notes}
            : null,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(
      int id, String reason) async {
    try {
      await api.put(
        ApiEndpoints.cancelAppointment(id),
        queryParameters: {'reason': reason},
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, void>> noShowAppointment(int id) async {
    try {
      await api.put(ApiEndpoints.noShowAppointment(id));
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
