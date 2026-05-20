import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../medical_report/domin/entity/prescription_entity.dart';
import '../repo/prescription_repo_interface.dart';

/// Fetches active prescriptions first; falls back to all prescriptions.
class GetPrescriptionsUseCase {
  final PrescriptionRepository repository;

  GetPrescriptionsUseCase(this.repository);

  Future<Either<Failure, List<PrescriptionEntity>>> call(int patientId) async {
    final activeResult = await repository.getActivePrescriptions(patientId);

    return activeResult.fold(
      (_) => repository.getAllPrescriptions(patientId),
      (list) async {
        if (list.isEmpty) {
          return repository.getAllPrescriptions(patientId);
        }
        return Right(list);
      },
    );
  }
}
