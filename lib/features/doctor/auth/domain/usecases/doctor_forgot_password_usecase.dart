import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../repositories/doctor_auth_repository.dart';

class DoctorForgotPasswordUseCase implements UseCase<Unit, String> {
  final DoctorAuthRepository _repository;

  DoctorForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String email) {
    return _repository.forgotPassword(email);
  }
}
