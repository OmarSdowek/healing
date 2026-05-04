import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../entities/doctor_schedule_entity.dart';
import '../repositories/doctor_schedule_repository.dart';

class GetDoctorSchedulesUseCase
    implements UseCase<List<DoctorScheduleEntity>, void> {
  final DoctorScheduleRepository _repository;

  GetDoctorSchedulesUseCase(this._repository);

  @override
  Future<Either<Failure, List<DoctorScheduleEntity>>> call(void params) {
    return _repository.getSchedules();
  }
}
