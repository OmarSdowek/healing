

import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/use_case.dart';

import '../repo/auth_repo_interface.dart';

class LoginUseCase extends UseCase{
  final AuthRepoInterface authRepoInterface;

  LoginUseCase(this.authRepoInterface);

  @override
  Future<Either<Failure, dynamic>> call(p) async{
    return await authRepoInterface.login(p);

  }


}