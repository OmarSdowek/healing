import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../entities/doctor_profile_entity.dart';
import '../repositories/doctor_profile_repository.dart';

class GetDoctorProfileUseCase implements UseCase<DoctorProfileEntity, void> {
  final DoctorProfileRepository _repository;

  GetDoctorProfileUseCase(this._repository);

  @override
  Future<Either<Failure, DoctorProfileEntity>> call(void params) {
    return _repository.getProfile();
  }
}
