import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/appointment_entity.dart';

abstract class AppointmentRepo {
  // ─── Patient role ──────────────────────────────────────────────────────────

  /// GET /api/Appointments/patient/{patientId}
  Future<Either<Failure, List<AppointmentEntity>>> getPatientAppointments(
      int patientId);

  /// GET /api/Appointments/{id}
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(int id);

  /// POST /api/Appointments
  Future<Either<Failure, AppointmentEntity>> bookAppointment(
      Map<String, dynamic> body);

  /// PUT /api/Appointments/{id}/cancel?reason={reason}
  Future<Either<Failure, void>> cancelAppointment(
      int appointmentId, String reason);
}
