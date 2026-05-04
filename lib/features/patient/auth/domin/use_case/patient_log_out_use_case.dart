import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/no_param_use_case.dart';
import '../repo/auth_repo_interface.dart';

class PatientLogOutUseCase extends UseCase{
  final AuthRepoInterface _authRepo;

  PatientLogOutUseCase(this._authRepo);

  @override
  Future<Either<Failure, dynamic>> call() async{
    return await _authRepo.logout();

  }

}