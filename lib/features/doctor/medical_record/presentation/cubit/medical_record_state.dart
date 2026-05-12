part of 'medical_record_cubit.dart';

abstract class DoctorMedicalRecordState {}

class DoctorMedicalRecordInitial extends DoctorMedicalRecordState {}

class DoctorMedicalRecordLoading extends DoctorMedicalRecordState {}

class DoctorMedicalRecordSuccess extends DoctorMedicalRecordState {
  final String message;
   DoctorMedicalRecordSuccess(this.message);
}

class DoctorMedicalRecordError extends DoctorMedicalRecordState {
  final String message;
  DoctorMedicalRecordError(this.message);
}

class PatientDetailsLoaded extends DoctorMedicalRecordState {
  final PatientDetailsEntity details;
  PatientDetailsLoaded(this.details);
}

class MedicalRecordCreated extends DoctorMedicalRecordState {
  final MedicalRecordEntity record;
  MedicalRecordCreated(this.record);
}

class PatientRecordsLoaded extends DoctorMedicalRecordState {
  final List<MedicalRecordEntity> records;
  PatientRecordsLoaded(this.records);
}
