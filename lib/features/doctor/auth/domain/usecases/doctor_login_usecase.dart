import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../../data/models/doctor_auth_response.dart';
import '../../data/models/doctor_login_request.dart';
import '../repositories/doctor_auth_repository.dart';

class DoctorLoginUseCase
    implements UseCase<DoctorAuthResponse, DoctorLoginRequest> {
  final DoctorAuthRepository _repository;

  DoctorLoginUseCase(this._repository);

  @override
  Future<Either<Failure, DoctorAuthResponse>> call(DoctorLoginRequest params) {
    return _repository.login(params);
  }
}
