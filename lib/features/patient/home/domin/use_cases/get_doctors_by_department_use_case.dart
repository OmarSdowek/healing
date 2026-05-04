import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/doctor_entity.dart';
import '../repo/home_repo_interface.dart';

class GetDoctorsByDepartmentUseCase {
  final HomeRepo homeRepo;

  GetDoctorsByDepartmentUseCase(this.homeRepo);

  Future<Either<Failure, List<DoctorEntity>>> call(int deptId) async {
    return await homeRepo.getDoctorsByDepartment(deptId);
  }
}
