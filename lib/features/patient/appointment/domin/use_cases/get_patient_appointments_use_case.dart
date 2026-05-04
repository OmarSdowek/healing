import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/appointment_entity.dart';
import '../repo/appointment_repo.dart';

class GetPatientAppointmentsUseCase {
  final AppointmentRepo appointmentRepo;

  GetPatientAppointmentsUseCase(this.appointmentRepo);

  Future<Either<Failure, List<AppointmentEntity>>> call(int patientId) async {
    return await appointmentRepo.getPatientAppointments(patientId);
  }
}
