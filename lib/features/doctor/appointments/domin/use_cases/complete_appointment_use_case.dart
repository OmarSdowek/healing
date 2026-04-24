import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/use_case.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/domin/repo/doctor_appointments_repo.dart';

class CompleteAppointmentParams {
  final int id;
  final String? notes;
  CompleteAppointmentParams({required this.id, this.notes});
}

class CompleteAppointmentUseCase
    implements UseCase<AppointmentModel, CompleteAppointmentParams> {
  final DoctorAppointmentsRepo _repo;

  CompleteAppointmentUseCase(this._repo);

  @override
  Future<Either<Failure, AppointmentModel>> call(CompleteAppointmentParams p) =>
      _repo.completeAppointment(id: p.id, notes: p.notes);
}
