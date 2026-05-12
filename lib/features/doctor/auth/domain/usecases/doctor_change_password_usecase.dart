import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/doctor_auth_repository.dart';

class DoctorChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  const DoctorChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

class DoctorChangePasswordUseCase {
  final DoctorAuthRepository _repository;

  DoctorChangePasswordUseCase(this._repository);

  Future<Either<Failure, Unit>> call(DoctorChangePasswordParams params) {
    return _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
