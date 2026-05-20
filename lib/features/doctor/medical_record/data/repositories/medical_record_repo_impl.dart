import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../../domain/entities/medical_record_request.dart';
import '../../domain/repositories/medical_record_repo.dart';
import '../mappers/medical_record_mapper.dart';

/// Responsible only for API communication for medical records.
/// Parsing is delegated to [MedicalRecordMapper].
class DoctorMedicalRecordRepoImpl implements DoctorMedicalRecordRepo {
  final ApiService api;

  DoctorMedicalRecordRepoImpl(this.api);

  // ─── POST /api/medical-records ────────────────────────────────────────────
  @override
  Future<Either<Failure, MedicalRecordEntity>> createRecord(
      CreateMedicalRecordRequest request) async {
    try {
      final response = await api.post(
        ApiEndpoints.createMedicalRecord,
        data: request.toJson(),
      );
      return Right(MedicalRecordMapper.toEntity(response.data));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── POST /api/medical-records/{id}/prescriptions ─────────────────────────
  @override
  Future<Either<Failure, void>> addPrescription(
      int recordId, AddPrescriptionRequest request) async {
    try {
      await api.post(
        ApiEndpoints.addPrescriptionToRecord(recordId),
        data: request.toJson(),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── POST /api/medical-records/{id}/vitals ────────────────────────────────
  @override
  Future<Either<Failure, void>> addVitals(
      int recordId, AddVitalsRequest request) async {
    try {
      await api.post(
        ApiEndpoints.addVitals(recordId),
        data: request.toJson(),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/patients/{id}/details ──────────────────────────────────────
  @override
  Future<Either<Failure, PatientDetailsEntity>> getPatientDetails(
      int patientId) async {
    try {
      final response =
          await api.get(ApiEndpoints.getPatientDetails(patientId));

      debugPrint('🔎 getPatientDetails[$patientId] url: ${ApiEndpoints.getPatientDetails(patientId)}');
      debugPrint('🔎 getPatientDetails[$patientId] type: ${response.data.runtimeType}');
      debugPrint('🔎 getPatientDetails[$patientId] data: ${response.data}');

      return Right(MedicalRecordMapper.toPatientDetails(response.data));
    } on DioException catch (e) {
      debugPrint('❌ getPatientDetails[$patientId] error: ${e.response?.statusCode} ${e.message}');
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/medical-records/patient/{id} ────────────────────────────────
  @override
  Future<Either<Failure, List<MedicalRecordEntity>>> getPatientRecords(
      int patientId) async {
    try {
      final response = await api.get(
        ApiEndpoints.getMedicalReports(patientId),
      );
      final raw = response.data;
      final List<dynamic> data;
      if (raw is Map) {
        data = (raw['data'] ?? raw['items'] ?? []) as List;
      } else if (raw is List) {
        data = raw;
      } else {
        data = [];
      }
      return Right(data.map(MedicalRecordMapper.toEntity).toList());
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
