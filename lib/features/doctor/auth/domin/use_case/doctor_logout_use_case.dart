import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/no_param_use_case.dart';
import 'package:healing/features/doctor/auth/domin/repo/doctor_auth_repo.dart';

class DoctorLogoutUseCase implements UseCase<Unit> {
  final DoctorAuthRepo _repo;

  DoctorLogoutUseCase(this._repo);

  @override
  Future<Either<Failure, Unit>> call() => _repo.logout();
}
