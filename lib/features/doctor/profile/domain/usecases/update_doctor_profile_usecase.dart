import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../entities/doctor_profile_entity.dart';
import '../repositories/doctor_profile_repository.dart';

class UpdateDoctorProfileUseCase implements UseCase<Unit, DoctorProfileEntity> {
  final DoctorProfileRepository _repository;

  UpdateDoctorProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DoctorProfileEntity params) {
    return _repository.updateProfile(params);
  }
}
