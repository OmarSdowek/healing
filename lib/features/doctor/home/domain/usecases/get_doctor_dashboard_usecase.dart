import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../entities/doctor_dashboard_entity.dart';
import '../repositories/doctor_home_repository.dart';

class GetDoctorDashboardUseCase
    implements UseCase<DoctorDashboardEntity, void> {
  final DoctorHomeRepository _repository;

  GetDoctorDashboardUseCase(this._repository);

  @override
  Future<Either<Failure, DoctorDashboardEntity>> call(void params) {
    return _repository.getDashboard();
  }
}
