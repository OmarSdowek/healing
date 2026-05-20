import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../medical_report/domin/entity/prescription_entity.dart';

abstract class PrescriptionRepository {
  /// GET /api/patients/{patientId}/prescriptions/active
  Future<Either<Failure, List<PrescriptionEntity>>> getActivePrescriptions(
      int patientId);

  /// GET /api/patients/{patientId}/prescriptions
  Future<Either<Failure, List<PrescriptionEntity>>> getAllPrescriptions(
      int patientId);

  /// GET /api/patients/{patientId}/prescriptions/{prescriptionId}/pdf
  /// Returns the local file path after saving to device storage.
  Future<Either<Failure, String>> downloadPrescriptionPdf({
    required int patientId,
    required String prescriptionId,
  });
}
