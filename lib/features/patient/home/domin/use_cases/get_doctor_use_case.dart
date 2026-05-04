import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/doctor_entity.dart';
import '../repo/home_repo_interface.dart';

/// GET /api/Doctors?status=Active&pageSize=20
/// Returns all active doctors (paginated, page 1)
class GetDoctorUseCase {
  final HomeRepo repo;
  GetDoctorUseCase(this.repo);

  Future<Either<Failure, List<DoctorEntity>>> call() =>
      repo.getDoctors();
}
