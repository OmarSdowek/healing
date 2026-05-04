import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/medical_report_entity.dart';
import '../entity/prescription_entity.dart';

abstract class MedicalReportRepo {
  /// GET /api/medical-records/patient/{patientId}
  Future<Either<Failure, List<MedicalReportEntity>>> getReports(int patientId);

  /// GET /api/medical-records/{id}
  Future<Either<Failure, MedicalReportDetailEntity>> getReportDetail(
      String reportId);

  /// GET /api/patients/{patientId}/prescriptions
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions(
      int patientId);

  /// GET /api/patients/{patientId}/prescriptions/active
  Future<Either<Failure, List<PrescriptionEntity>>> getActivePrescriptions(
      int patientId);
}
