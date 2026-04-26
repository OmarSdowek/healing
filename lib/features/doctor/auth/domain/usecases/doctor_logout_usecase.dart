import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../repositories/doctor_auth_repository.dart';

class DoctorLogoutUseCase implements UseCase<Unit, void> {
  final DoctorAuthRepository _repository;

  DoctorLogoutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(void params) {
    return _repository.logout();
  }
}
