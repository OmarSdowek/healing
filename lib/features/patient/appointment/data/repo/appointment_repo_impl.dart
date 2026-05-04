import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/network/token_storage.dart';
import '../../domin/entity/appointment_entity.dart';
import '../../domin/repo/appointment_repo.dart';
import '../model/appointment_model.dart';

class AppointmentRepoImpl implements AppointmentRepo {
  final ApiService api;
  AppointmentRepoImpl(this.api);

  // ─── GET /api/Appointments/patient/{patientId} ────────────────────────────
  @override
  Future<Either<Failure, List<AppointmentEntity>>> getPatientAppointments(
      int patientId) async {
    try {
      print("🔥 AppointmentRepo: getPatientAppointments($patientId)");
      final token = await TokenStorage.getAccessToken();
      print("🔥 Token exists: ${token != null}");

      final response =
          await api.get(ApiEndpoints.getPatientAppointments(patientId));

      if (response.data == null) return const Right([]);

      final raw = response.data;
      print("🔥 Appointments raw type: ${raw.runtimeType}");
      print("🔥 Appointments raw: $raw");

      // Handle both List and paginated {data: [...]}
      List<dynamic> data;
      if (raw is List) {
        data = raw;
      } else if (raw is Map) {
        data = (raw['data'] ?? raw['items'] ?? raw['appointments'] ?? []) as List;
      } else {
        data = [];
      }

      print("🔥 Appointments count: ${data.length}");
      if (data.isNotEmpty) {
        print("🔥 First raw item: ${data.first}");
      }

      final appointments =
          data.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>)).toList();

      print("✅ Parsed ${appointments.length} appointments");
      if (appointments.isNotEmpty) {
        final f = appointments.first;
        print("🔥 First: id=${f.id}, doctor=${f.doctorName}, date=${f.appointmentDate}, status=${f.status}");
      }
      return Right(appointments);
    } on DioException catch (e) {
      print("❌ getPatientAppointments: ${e.response?.statusCode}");
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure("Failed to load appointments: $e"));
    }
  }

  // ─── GET /api/Appointments/{id} ───────────────────────────────────────────
  @override
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(int id) async {
    try {
      print("🔥 AppointmentRepo: getAppointmentById($id)");
      final response = await api.get(ApiEndpoints.getAppointmentById(id));

      final appointment = AppointmentModel.fromJson(
          response.data as Map<String, dynamic>);

      print("✅ Got appointment: ${appointment.confirmationNumber}");
      return Right(appointment);
    } on DioException catch (e) {
      print("❌ getAppointmentById: ${e.response?.statusCode}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── POST /api/Appointments ───────────────────────────────────────────────
  @override
  Future<Either<Failure, AppointmentEntity>> bookAppointment(
      Map<String, dynamic> body) async {
    try {
      print("🔥 AppointmentRepo: bookAppointment()");
      final response =
          await api.post(ApiEndpoints.bookAppointment, data: body);

      final appointment = AppointmentModel.fromJson(
          response.data as Map<String, dynamic>);

      print("✅ Booked: ${appointment.confirmationNumber}");
      return Right(appointment);
    } on DioException catch (e) {
      print("❌ bookAppointment: ${e.response?.statusCode} - ${e.message}");
      print("❌ body: ${e.response?.data}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── PUT /api/Appointments/{id}/cancel?reason={reason} ───────────────────
  @override
  Future<Either<Failure, void>> cancelAppointment(
      int appointmentId, String reason) async {
    try {
      print("🔥 AppointmentRepo: cancelAppointment($appointmentId)");
      await api.put(
        ApiEndpoints.cancelAppointment(appointmentId),
        queryParameters: {"reason": reason},
      );

      print("✅ Appointment $appointmentId cancelled");
      return const Right(null);
    } on DioException catch (e) {
      print("❌ cancelAppointment: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
