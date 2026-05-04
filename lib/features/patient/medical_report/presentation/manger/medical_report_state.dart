part of 'medical_report_cubit.dart';

abstract class MedicalReportState {}

class MedicalReportInitial extends MedicalReportState {}

class MedicalReportLoading extends MedicalReportState {}

class MedicalReportError extends MedicalReportState {
  final String message;
  MedicalReportError(this.message);
}

class MedicalReportsLoaded extends MedicalReportState {
  final List<MedicalReportEntity> reports;
  MedicalReportsLoaded(this.reports);
}

class MedicalReportDetailLoaded extends MedicalReportState {
  final MedicalReportDetailEntity detail;
  MedicalReportDetailLoaded(this.detail);
}

class PrescriptionsLoaded extends MedicalReportState {
  final List<PrescriptionEntity> prescriptions;
  PrescriptionsLoaded(this.prescriptions);
}

class PrescriptionDetailLoaded extends MedicalReportState {
  final PrescriptionEntity prescription;
  PrescriptionDetailLoaded(this.prescription);
}
