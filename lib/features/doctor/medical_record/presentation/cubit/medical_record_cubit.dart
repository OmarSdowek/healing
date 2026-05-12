import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../../domain/entities/medical_record_request.dart';
import '../../domain/repositories/medical_record_repo.dart';

part 'medical_record_state.dart';

class DoctorMedicalRecordCubit extends Cubit<DoctorMedicalRecordState> {
  final DoctorMedicalRecordRepo repo;

  DoctorMedicalRecordCubit(this.repo) : super(DoctorMedicalRecordInitial());

  MedicalRecordEntity? _createdRecord;
  MedicalRecordEntity? get createdRecord => _createdRecord;

  Future<void> loadPatientDetails(int patientId) async {
    emit(DoctorMedicalRecordLoading());
    final result = await repo.getPatientDetails(patientId);
    result.fold(
      (f) => emit(DoctorMedicalRecordError(f.massage)),
      (details) => emit(PatientDetailsLoaded(details)),
    );
  }

  Future<void> createRecord(CreateMedicalRecordRequest request) async {
    emit(DoctorMedicalRecordLoading());
    final result = await repo.createRecord(request);
    result.fold(
      (f) => emit(DoctorMedicalRecordError(f.massage)),
      (record) {
        _createdRecord = record;
        emit(MedicalRecordCreated(record));
      },
    );
  }

  Future<void> addPrescription(
      int recordId, AddPrescriptionRequest request) async {
    emit(DoctorMedicalRecordLoading());
    final result = await repo.addPrescription(recordId, request);
    result.fold(
      (f) => emit(DoctorMedicalRecordError(f.massage)),
      (_) => emit( DoctorMedicalRecordSuccess('Prescription added')),
    );
  }

  Future<void> addVitals(int recordId, AddVitalsRequest request) async {
    emit(DoctorMedicalRecordLoading());
    final result = await repo.addVitals(recordId, request);
    result.fold(
      (f) => emit(DoctorMedicalRecordError(f.massage)),
      (_) => emit( DoctorMedicalRecordSuccess('Vitals recorded')),
    );
  }

  Future<void> loadPatientRecords(int patientId) async {
    emit(DoctorMedicalRecordLoading());
    final result = await repo.getPatientRecords(patientId);
    result.fold(
      (f) => emit(DoctorMedicalRecordError(f.massage)),
      (records) => emit(PatientRecordsLoaded(records)),
    );
  }
}
