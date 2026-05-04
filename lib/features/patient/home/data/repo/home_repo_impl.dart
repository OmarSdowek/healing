import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domin/entity/doctor_entity.dart';
import '../../domin/repo/home_repo_interface.dart';
import '../model/department_model.dart';
import '../models/doctor_model.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService api;
  HomeRepoImpl(this.api);

  // ─── GET /api/Doctors?status=Active&pageSize=20 ───────────────────────────
  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors() async {
    try {
      print("🔥 HomeRepo: getDoctors() — GET /api/Doctors");
      final response = await api.get(
        ApiEndpoints.getDoctors,
        queryParameters: {
          'pageIndex': 1,
          'pageSize': 50, // get all doctors
        },
      );

      print("🔥 HomeRepo: response type=${response.data.runtimeType}");

      final raw = response.data;
      List<dynamic> data;

      if (raw is Map) {
        // Paginated: { data: [...] }
        data = (raw['data'] as List?) ?? [];
      } else if (raw is List) {
        data = raw;
      } else {
        data = [];
      }

      print("🔥 HomeRepo: raw data length=${data.length}");

      if (data.isEmpty) {
        print("⚠️ HomeRepo: empty from /api/Doctors — fallback to available");
        return _getDoctorsFromAvailable();
      }

      final doctors = data.map((e) => DoctorModel.fromJson(e)).toList();
      print("✅ HomeRepo: Got ${doctors.length} doctors");
      return Right(doctors);
    } on DioException catch (e) {
      print("❌ getDoctors: ${e.response?.statusCode} — fallback to available");
      return _getDoctorsFromAvailable();
    }
  }

  /// Fallback: GET /api/Doctors/available?date={today}
  Future<Either<Failure, List<DoctorEntity>>> _getDoctorsFromAvailable() async {
    try {
      final today = DateTime.now().toIso8601String();
      final response = await api.get(ApiEndpoints.getAvailableDoctors(today));

      final raw = response.data;
      final data = raw is List ? raw : (raw is Map ? (raw['data'] as List? ?? []) : []);
      final doctors = (data as List).map((e) => DoctorModel.fromJson(e)).toList();
      print("✅ HomeRepo: Got ${doctors.length} doctors from available");
      return Right(doctors);
    } on DioException catch (e) {
      print("❌ _getDoctorsFromAvailable: ${e.response?.statusCode}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/department ──────────────────────────────────────────────────
  /// Departments list — 403 for Patient role, use fallback from doctors
  @override
  Future<Either<Failure, List<DepartmentModel>>> getDepartments() async {
    try {
      print("🔥 HomeRepo: getDepartments()");
      final response = await api.get(ApiEndpoints.getDepartments);

      final data = response.data as List;
      final departments =
          data.map((e) => DepartmentModel.fromJson(e)).toList();

      print("✅ HomeRepo: Got ${departments.length} departments");
      return Right(departments);
    } on DioException catch (e) {
      print("❌ getDepartments: ${e.response?.statusCode} — expected 403 for Patient role");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/Doctors/department/{deptId} ────────────────────────────────
  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsByDepartment(
      int deptId) async {
    try {
      print("🔥 HomeRepo: getDoctorsByDepartment($deptId)");
      final response =
          await api.get(ApiEndpoints.getDoctorsByDepartment(deptId));

      final data = response.data as List;
      final doctors = data.map((e) => DoctorModel.fromJson(e)).toList();

      print("✅ HomeRepo: Got ${doctors.length} doctors for dept $deptId");
      return Right(doctors);
    } on DioException catch (e) {
      print("❌ getDoctorsByDepartment: ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
