import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../../data/models/patient_auth_response.dart';
import '../../data/models/patient_login_request.dart';
import '../repositories/patient_auth_repository.dart';

class PatientLoginUseCase
    implements UseCase<PatientAuthResponse, PatientLoginRequest> {
  final PatientAuthRepository _repository;

  PatientLoginUseCase(this._repository);

  @override
  Future<Either<Failure, PatientAuthResponse>> call(
    PatientLoginRequest params,
  ) {
    return _repository.login(params);
  }
}
