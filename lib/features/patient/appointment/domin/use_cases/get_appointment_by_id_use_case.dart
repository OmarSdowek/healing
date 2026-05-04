import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/appointment_entity.dart';
import '../repo/appointment_repo.dart';

class GetAppointmentByIdUseCase {
  final AppointmentRepo repo;
  GetAppointmentByIdUseCase(this.repo);

  Future<Either<Failure, AppointmentEntity>> call(int id) =>
      repo.getAppointmentById(id);
}
