import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/model/department_model.dart';
import '../entity/doctor_entity.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<DoctorEntity>>> getDoctors();
  Future<Either<Failure, List<DepartmentModel>>> getDepartments();
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsByDepartment(int deptId);
}
