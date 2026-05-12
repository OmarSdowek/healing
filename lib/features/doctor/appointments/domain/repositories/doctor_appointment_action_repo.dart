import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

abstract class DoctorAppointmentActionRepo {
  /// PUT /api/appointments/{id}/confirm
  Future<Either<Failure, void>> confirmAppointment(int id);

  /// PUT /api/appointments/{id}/complete?notes={notes}
  Future<Either<Failure, void>> completeAppointment(int id, {String? notes});

  /// PUT /api/appointments/{id}/cancel?reason={reason}
  Future<Either<Failure, void>> cancelAppointment(int id, String reason);

  /// PUT /api/appointments/{id}/no-show
  Future<Either<Failure, void>> noShowAppointment(int id);
}
