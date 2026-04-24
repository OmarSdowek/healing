import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/use_case.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/domin/repo/doctor_appointments_repo.dart';

class GetDoctorAppointmentsParams {
  final int doctorId;
  final String? date;

  GetDoctorAppointmentsParams({required this.doctorId, this.date});
}

class GetDoctorAppointmentsUseCase
    implements UseCase<List<AppointmentModel>, GetDoctorAppointmentsParams> {
  final DoctorAppointmentsRepo _repo;

  GetDoctorAppointmentsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AppointmentModel>>> call(
    GetDoctorAppointmentsParams p,
  ) => _repo.getDoctorAppointments(doctorId: p.doctorId, date: p.date);
}
