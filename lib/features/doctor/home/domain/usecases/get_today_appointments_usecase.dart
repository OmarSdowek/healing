import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../entities/doctor_appointment_entity.dart';
import '../repositories/doctor_home_repository.dart';

class GetTodayAppointmentsUseCase
    implements UseCase<List<DoctorAppointmentEntity>, void> {
  final DoctorHomeRepository _repository;

  GetTodayAppointmentsUseCase(this._repository);

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> call(void params) {
    return _repository.getTodayAppointments();
  }
}
