import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/use_case.dart';
import 'package:healing/features/doctor/auth/data/models/doctor_auth_response.dart';
import 'package:healing/features/doctor/auth/data/models/doctor_login_request.dart';
import 'package:healing/features/doctor/auth/domin/repo/doctor_auth_repo.dart';

class DoctorLoginUseCase
    implements UseCase<DoctorAuthResponse, DoctorLoginRequest> {
  final DoctorAuthRepo _repo;

  DoctorLoginUseCase(this._repo);

  @override
  Future<Either<Failure, DoctorAuthResponse>> call(DoctorLoginRequest p) =>
      _repo.login(p);
}
