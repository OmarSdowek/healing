import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/model/department_model.dart';
import '../repo/home_repo_interface.dart';

class GetDepartmentsUseCase {
  final HomeRepo homeRepo;

  GetDepartmentsUseCase(this.homeRepo);

  Future<Either<Failure, List<DepartmentModel>>> call() async {
    return await homeRepo.getDepartments();
  }
}
