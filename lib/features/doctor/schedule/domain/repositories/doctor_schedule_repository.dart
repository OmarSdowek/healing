import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/doctor_schedule_entity.dart';

abstract class DoctorScheduleRepository {
  Future<Either<Failure, List<DoctorScheduleEntity>>> getSchedules();
  Future<Either<Failure, DoctorScheduleEntity>> updateSchedule(
    int scheduleId,
    DoctorScheduleEntity schedule,
  );
}
