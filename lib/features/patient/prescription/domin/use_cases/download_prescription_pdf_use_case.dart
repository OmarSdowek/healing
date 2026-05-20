import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repo/prescription_repo_interface.dart';

class DownloadPrescriptionPdfUseCase {
  final PrescriptionRepository repository;

  DownloadPrescriptionPdfUseCase(this.repository);

  /// Returns the local file path on success.
  Future<Either<Failure, String>> call({
    required int patientId,
    required String prescriptionId,
  }) =>
      repository.downloadPrescriptionPdf(
        patientId: patientId,
        prescriptionId: prescriptionId,
      );
}
