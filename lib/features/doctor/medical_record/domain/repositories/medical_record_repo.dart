import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/medical_record_entity.dart';
import '../entities/medical_record_request.dart';

abstract class DoctorMedicalRecordRepo {
  Future<Either<Failure, MedicalRecordEntity>> createRecord(
      CreateMedicalRecordRequest request);

  Future<Either<Failure, void>> addPrescription(
      int recordId, AddPrescriptionRequest request);

  Future<Either<Failure, void>> addVitals(
      int recordId, AddVitalsRequest request);

  Future<Either<Failure, PatientDetailsEntity>> getPatientDetails(
      int patientId);

  Future<Either<Failure, List<MedicalRecordEntity>>> getPatientRecords(
      int patientId);
}
