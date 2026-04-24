import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';

abstract class DoctorAppointmentsRepo {
  Future<Either<Failure, List<AppointmentModel>>> getDoctorAppointments({
    required int doctorId,
    String? date,
  });
  Future<Either<Failure, AppointmentModel>> getAppointmentById(int id);
  Future<Either<Failure, AppointmentModel>> confirmAppointment(int id);
  Future<Either<Failure, AppointmentModel>> completeAppointment({
    required int id,
    String? notes,
  });
  Future<Either<Failure, Unit>> cancelAppointment({
    required int id,
    required String reason,
  });
  Future<Either<Failure, Unit>> markNoShow(int id);
}
