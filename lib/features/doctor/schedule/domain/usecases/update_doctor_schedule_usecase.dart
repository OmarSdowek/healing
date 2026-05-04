import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../entities/doctor_schedule_entity.dart';
import '../repositories/doctor_schedule_repository.dart';

class UpdateDoctorScheduleParams {
  final int scheduleId;
  final DoctorScheduleEntity schedule;

  UpdateDoctorScheduleParams({
    required this.scheduleId,
    required this.schedule,
  });
}

class UpdateDoctorScheduleUseCase
    implements UseCase<DoctorScheduleEntity, UpdateDoctorScheduleParams> {
  final DoctorScheduleRepository _repository;

  UpdateDoctorScheduleUseCase(this._repository);

  @override
  Future<Either<Failure, DoctorScheduleEntity>> call(
    UpdateDoctorScheduleParams params,
  ) {
    return _repository.updateSchedule(params.scheduleId, params.schedule);
  }
}
