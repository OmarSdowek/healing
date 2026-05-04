import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/medical_report_entity.dart';
import '../entity/prescription_entity.dart';
import '../repo/medical_report_repo.dart';

class GetReportsUseCase {
  final MedicalReportRepo repo;
  GetReportsUseCase(this.repo);

  Future<Either<Failure, List<MedicalReportEntity>>> call(int patientId) =>
      repo.getReports(patientId);
}

class GetReportDetailUseCase {
  final MedicalReportRepo repo;
  GetReportDetailUseCase(this.repo);

  Future<Either<Failure, MedicalReportDetailEntity>> call(String reportId) =>
      repo.getReportDetail(reportId);
}

/// GET /api/patients/{patientId}/prescriptions — all prescriptions
class GetPrescriptionsUseCase {
  final MedicalReportRepo repo;
  GetPrescriptionsUseCase(this.repo);

  Future<Either<Failure, List<PrescriptionEntity>>> call(int patientId) =>
      repo.getPrescriptions(patientId);
}

/// GET /api/patients/{patientId}/prescriptions/active — active only
class GetActivePrescriptionsUseCase {
  final MedicalReportRepo repo;
  GetActivePrescriptionsUseCase(this.repo);

  Future<Either<Failure, List<PrescriptionEntity>>> call(int patientId) =>
      repo.getActivePrescriptions(patientId);
}
