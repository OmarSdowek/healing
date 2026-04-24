import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:healing/core/constant/api_endpoint.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/network/error_handling.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_model.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_request.dart';
import 'package:healing/features/doctor/prescription/domin/repo/prescription_repo.dart';

class PrescriptionRepoImpl implements PrescriptionRepo {
  final ApiService _api;

  PrescriptionRepoImpl(this._api);

  @override
  Future<Either<Failure, PrescriptionModel>> addPrescription({
    required int medicalRecordId,
    required PrescriptionRequest request,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.prescriptions(medicalRecordId),
        data: request.toJson(),
      );
      return Right(PrescriptionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelPrescription({
    required int medicalRecordId,
    required int prescriptionId,
  }) async {
    try {
      await _api.delete(
        ApiEndpoints.cancelPrescription(medicalRecordId, prescriptionId),
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
