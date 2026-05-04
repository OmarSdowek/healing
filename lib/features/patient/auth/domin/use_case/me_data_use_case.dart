import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/no_param_use_case.dart';
import '../../data/model/me_data_model.dart';
import '../repo/auth_repo_interface.dart';

class MeDataUseCase extends UseCase<MeDataModel> {
  final AuthRepoInterface authRepoInterface;

  MeDataUseCase(this.authRepoInterface);

  @override
  Future<Either<Failure, MeDataModel>> call() async {
    print("🔥 MeDataUseCase: call() invoked");
    final result = await authRepoInterface.meData();
    print("🔥 MeDataUseCase: Repository call completed");
    return result;
  }
}