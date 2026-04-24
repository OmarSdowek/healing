import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/use_case/use_case.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_model.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_request.dart';
import 'package:healing/features/doctor/prescription/domin/repo/prescription_repo.dart';

class AddPrescriptionParams {
  final int medicalRecordId;
  final PrescriptionRequest request;

  AddPrescriptionParams({required this.medicalRecordId, required this.request});
}

class AddPrescriptionUseCase
    implements UseCase<PrescriptionModel, AddPrescriptionParams> {
  final PrescriptionRepo _repo;

  AddPrescriptionUseCase(this._repo);

  @override
  Future<Either<Failure, PrescriptionModel>> call(AddPrescriptionParams p) =>
      _repo.addPrescription(
        medicalRecordId: p.medicalRecordId,
        request: p.request,
      );
}
