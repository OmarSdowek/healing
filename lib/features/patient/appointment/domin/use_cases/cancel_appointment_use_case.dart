import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repo/appointment_repo.dart';

class CancelAppointmentUseCase {
  final AppointmentRepo appointmentRepo;

  CancelAppointmentUseCase(this.appointmentRepo);

  Future<Either<Failure, void>> call(int appointmentId, String reason) async {
    return await appointmentRepo.cancelAppointment(appointmentId, reason);
  }
}
