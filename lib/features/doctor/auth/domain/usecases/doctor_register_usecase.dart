import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../../data/models/doctor_auth_response.dart';
import '../../data/models/doctor_register_request.dart';
import '../repositories/doctor_auth_repository.dart';

class DoctorRegisterUseCase
    implements UseCase<DoctorAuthResponse, DoctorRegisterRequest> {
  final DoctorAuthRepository _repository;

  DoctorRegisterUseCase(this._repository);

  @override
  Future<Either<Failure, DoctorAuthResponse>> call(
      DoctorRegisterRequest params) {
    return _repository.register(params);
  }
}
