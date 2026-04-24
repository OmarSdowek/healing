import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_model.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_request.dart';

abstract class PrescriptionRepo {
  Future<Either<Failure, PrescriptionModel>> addPrescription({
    required int medicalRecordId,
    required PrescriptionRequest request,
  });
  Future<Either<Failure, Unit>> cancelPrescription({
    required int medicalRecordId,
    required int prescriptionId,
  });
}
