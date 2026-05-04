import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/use_case.dart';
import '../repo/auth_repo_interface.dart';


class VerifyEmailUseCaseImpl extends UseCase {
  final AuthRepoInterface authRepoInterface;

  VerifyEmailUseCaseImpl(this.authRepoInterface);

  @override
  Future<Either<Failure, Unit>> call(token) {
    return authRepoInterface.verifyEmail(token);

  }

}