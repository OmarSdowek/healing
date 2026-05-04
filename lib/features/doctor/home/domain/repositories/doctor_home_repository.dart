import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/doctor_dashboard_entity.dart';
import '../entities/doctor_appointment_entity.dart';

abstract class DoctorHomeRepository {
  Future<Either<Failure, DoctorDashboardEntity>> getDashboard();
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getTodayAppointments();
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getAppointmentsByDate(
    String date,
  );
}
