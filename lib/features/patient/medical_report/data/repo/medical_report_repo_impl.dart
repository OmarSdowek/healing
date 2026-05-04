import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domin/entity/medical_report_entity.dart';
import '../../domin/entity/prescription_entity.dart';
import '../../domin/repo/medical_report_repo.dart';
import '../model/medical_report_model.dart';
import '../model/prescription_model.dart';

class MedicalReportRepoImpl implements MedicalReportRepo {
  final ApiService api;
  MedicalReportRepoImpl(this.api);

  // ─── GET /api/medical-records/patient/{patientId} ─────────────────────────
  @override
  Future<Either<Failure, List<MedicalReportEntity>>> getReports(
      int patientId) async {
    try {
      print("🔥 MedicalReportRepo: getReports($patientId)");
      final response =
          await api.get(ApiEndpoints.getMedicalReports(patientId));

      final raw = response.data;
      List<dynamic> data;
      if (raw is Map) {
        data = (raw['data'] ?? raw['items'] ?? raw['records'] ?? []) as List;
      } else if (raw is List) {
        data = raw;
      } else {
        data = [];
      }

      final reports =
          data.map((e) => MedicalReportModel.fromJson(e)).toList();
      print("✅ Got ${reports.length} medical reports");
      return Right(reports);
    } on DioException catch (e) {
      print("❌ getReports: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/medical-records/{id} ───────────────────────────────────────
  @override
  Future<Either<Failure, MedicalReportDetailEntity>> getReportDetail(
      String reportId) async {
    try {
      print("🔥 MedicalReportRepo: getReportDetail($reportId)");
      final response =
          await api.get(ApiEndpoints.getMedicalReportDetail(reportId));
      final detail = MedicalReportDetailModel.fromJson(
          response.data as Map<String, dynamic>);
      return Right(detail);
    } on DioException catch (e) {
      print("❌ getReportDetail: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/patients/{patientId}/prescriptions ─────────────────────────
  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions(
      int patientId) async {
    try {
      print("🔥 MedicalReportRepo: getPrescriptions($patientId)");
      final response =
          await api.get(ApiEndpoints.getPrescriptions(patientId));
      return Right(_parsePrescriptions(response.data));
    } on DioException catch (e) {
      print("❌ getPrescriptions: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/patients/{patientId}/prescriptions/active ──────────────────
  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getActivePrescriptions(
      int patientId) async {
    try {
      print("🔥 MedicalReportRepo: getActivePrescriptions($patientId)");
      final response =
          await api.get(ApiEndpoints.getActivePrescriptions(patientId));
      return Right(_parsePrescriptions(response.data));
    } on DioException catch (e) {
      print("❌ getActivePrescriptions: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  List<PrescriptionEntity> _parsePrescriptions(dynamic raw) {
    List<dynamic> data;
    if (raw is Map) {
      data = (raw['data'] ?? raw['items'] ?? []) as List;
    } else if (raw is List) {
      data = raw;
    } else {
      data = [];
    }
    final list = data.map((e) => PrescriptionModel.fromJson(e)).toList();
    print("✅ Parsed ${list.length} prescriptions");
    return list;
  }
}
