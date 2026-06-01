import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../repositories/doctor_auth_repository.dart';

class DoctorResetPasswordParams {
  final String token;
  final String newPassword;
  DoctorResetPasswordParams({required this.token, required this.newPassword});
}

class DoctorResetPasswordUseCase
    implements UseCase<Unit, DoctorResetPasswordParams> {
  final DoctorAuthRepository _repository;

  DoctorResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DoctorResetPasswordParams params) {
    return _repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}
