import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/network/token_storage.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';
import '../../domain/repositories/doctor_home_repository.dart';
import '../models/doctor_appointment_model.dart';
import '../models/doctor_dashboard_model.dart';

class DoctorHomeRepositoryImpl implements DoctorHomeRepository {
  final ApiService _api;

  DoctorHomeRepositoryImpl(this._api);

  Future<String?> _getDoctorId() async {
    // Try to get from storage first
    var doctorId = await TokenStorage.getDoctorId();

    // If not in storage, try to extract from JWT token
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

            // Save it for future use
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
  Future<Either<Failure, DoctorDashboardEntity>> getDashboard() async {
    try {
      final doctorId = await _getDoctorId();
      if (doctorId == null) {
        return Left(Failure('Doctor ID not found'));
      }

      // Get today's appointments
      final today = DateTime.now().toString().split(' ')[0];
      final response = await _api.get(
        ApiEndpoints.doctorAppointments(int.parse(doctorId)),
        queryParameters: {'date': today},
      );

      final appointments = (response.data as List)
          .map((e) => DoctorAppointmentModel.fromJson(e))
          .toList();

      // Calculate dashboard stats from appointments
      int confirmedCount = 0;
      int pendingCount = 0;

      for (var appointment in appointments) {
        if (appointment.status?.toLowerCase() == 'confirmed') {
          confirmedCount++;
        } else if (appointment.status?.toLowerCase() == 'pending') {
          pendingCount++;
        }
      }

      // Build dashboard model from aggregated data
      final dashboard = DoctorDashboardModel(
        totalAppointmentsToday: appointments.length,
        confirmedAppointments: confirmedCount,
        pendingAppointments: pendingCount,
        totalPatients: appointments.length,
        todayAppointments: appointments,
      );

      return Right(dashboard);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
  getTodayAppointments() async {
    try {
      final doctorId = await _getDoctorId();
      if (doctorId == null) {
        return Left(Failure('Doctor ID not found'));
      }

      final today = DateTime.now().toString().split(' ')[0];
      final response = await _api.get(
        ApiEndpoints.doctorAppointments(int.parse(doctorId)),
        queryParameters: {'date': today},
      );

      final appointments = (response.data as List)
          .map((e) => DoctorAppointmentModel.fromJson(e))
          .toList();

      return Right(appointments);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getAppointmentsByDate(
    String date,
  ) async {
    try {
      final doctorId = await _getDoctorId();
      if (doctorId == null) {
        return Left(Failure('Doctor ID not found'));
      }

      final response = await _api.get(
        ApiEndpoints.doctorAppointments(int.parse(doctorId)),
        queryParameters: {'date': date},
      );

      final appointments = (response.data as List)
          .map((e) => DoctorAppointmentModel.fromJson(e))
          .toList();

      return Right(appointments);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
