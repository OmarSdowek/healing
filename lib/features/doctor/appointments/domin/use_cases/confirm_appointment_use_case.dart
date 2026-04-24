import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/use_case.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/domin/repo/doctor_appointments_repo.dart';

class ConfirmAppointmentUseCase implements UseCase<AppointmentModel, int> {
  final DoctorAppointmentsRepo _repo;

  ConfirmAppointmentUseCase(this._repo);

  @override
  Future<Either<Failure, AppointmentModel>> call(int p) =>
      _repo.confirmAppointment(p);
}
