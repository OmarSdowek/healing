import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repo/auth_repo_interface.dart';

class ChangePasswordUseCase {
  final AuthRepoInterface repo;
  ChangePasswordUseCase(this.repo);

  Future<Either<Failure, Unit>> call({
    required String currentPassword,
    required String newPassword,
  }) =>
      repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
}
