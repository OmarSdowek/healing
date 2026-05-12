import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/helper/jwt_helper.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/utils/appointment_date_helper.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';
import '../../domain/repositories/doctor_home_repository.dart';
import '../models/doctor_appointment_model.dart';
import '../models/doctor_dashboard_model.dart';

/// Fetches all doctor appointments in a single request.
/// JWT parsing → [JwtHelper], date formatting → [AppointmentDateHelper].
class DoctorHomeRepositoryImpl implements DoctorHomeRepository {
  final ApiService _api;

  DoctorHomeRepositoryImpl(this._api);

  // ─── Fetch ALL appointments — single request ──────────────────────────────
  // Response is grouped by patient:
  // [{ patientId, patientName, age, medicalRecordNumber, appointments: [...] }]
  // We flatten it into a List<DoctorAppointmentModel>.

  Future<List<DoctorAppointmentModel>> _fetchAllAppointments(
      String doctorId) async {
    try {
      final res = await _api.get(
        ApiEndpoints.doctorAllPatientAppointments(int.parse(doctorId)),
      );
      final raw = res.data;
      if (raw is List && raw.isNotEmpty) {
        return DoctorAppointmentModel.fromGroupedJson(raw);
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  // ─── Single date fetch (kept for dashboard today-only call) ───────────────

  Future<List<DoctorAppointmentModel>> _fetchForDate(
      String doctorId, String date) async {
    try {
      final res = await _api.get(
        ApiEndpoints.doctorAppointments(int.parse(doctorId)),
        queryParameters: {'date': date},
      );
      final raw = res.data;
      if (raw is List && raw.isNotEmpty) {
        // Old format: flat list of appointments
        return raw.map((e) => DoctorAppointmentModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  // ─── getDashboard — today stats + today appointments ─────────────────────

  @override
  Future<Either<Failure, DoctorDashboardEntity>> getDashboard() async {
    try {
      final doctorId = (await JwtHelper.getDoctorId()).toString();
      if (doctorId == '0') return Left(Failure('Doctor ID not found'));

      final doctorName = await JwtHelper.getFullName();
      final today = AppointmentDateHelper.formatDate(DateTime.now());

      final todayApts = await _fetchForDate(doctorId, today);
      todayApts.sort(
          (a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));

      final counts = _countStatuses(todayApts);

      return Right(DoctorDashboardModel(
        totalAppointmentsToday: todayApts.length,
        confirmedAppointments: counts['confirmed']!,
        pendingAppointments: counts['pending']!,
        totalPatients: todayApts.length,
        todayAppointments: todayApts,
        allAppointments: todayApts,
        doctorName: doctorName,
        doctorId: doctorId,
      ));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  // ─── getTodayAppointments ─────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getTodayAppointments() async {
    try {
      final doctorId = (await JwtHelper.getDoctorId()).toString();
      if (doctorId == '0') return Left(Failure('Doctor ID not found'));
      final list = await _fetchForDate(
          doctorId, AppointmentDateHelper.formatDate(DateTime.now()));
      return Right(list);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  // ─── getAppointmentsByDate ────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getAppointmentsByDate(
    String date,
  ) async {
    try {
      final doctorId = (await JwtHelper.getDoctorId()).toString();
      if (doctorId == '0') return Left(Failure('Doctor ID not found'));
      final list = await _fetchForDate(doctorId, date);
      return Right(list);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  // ─── getAllAppointments — ONE request, flatten grouped response ───────────

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getAllAppointments() async {
    try {
      final doctorId = (await JwtHelper.getDoctorId()).toString();
      if (doctorId == '0') return Left(Failure('Doctor ID not found'));

      final all = await _fetchAllAppointments(doctorId);
      return Right(all);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  Map<String, int> _countStatuses(List<DoctorAppointmentModel> apts) {
    int confirmed = 0, pending = 0;
    for (final apt in apts) {
      switch (apt.status?.toLowerCase()) {
        case 'confirmed':
          confirmed++;
          break;
        case 'scheduled':
        case 'pending':
          pending++;
          break;
      }
    }
    return {'confirmed': confirmed, 'pending': pending};
  }
}
