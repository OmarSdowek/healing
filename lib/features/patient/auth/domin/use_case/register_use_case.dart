import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/use_case.dart';

import '../repo/auth_repo_interface.dart';

class RegisterUseCase extends UseCase{
  final AuthRepoInterface authRepoInterface;

  RegisterUseCase(this.authRepoInterface);

  @override
  Future<Either<Failure, dynamic>> call(p) async{
   return await authRepoInterface.register(p);
  }


}