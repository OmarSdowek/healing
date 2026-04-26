import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/network/token_storage.dart';
import '../../domin/repositories/patient_auth_repository.dart';
import '../models/patient_auth_response.dart';
import '../models/patient_login_request.dart';

class PatientAuthRepositoryImpl implements PatientAuthRepository {
  final ApiService _api;

  PatientAuthRepositoryImpl(this._api);

  @override
  Future<Either<Failure, PatientAuthResponse>> login(
    PatientLoginRequest request,
  ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final auth = PatientAuthResponse.fromJson(response.data);

      // Save tokens and patient ID
      await TokenStorage.saveTokens(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        doctorId: auth.user.patientId,
      );

      return Right(auth);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _api.post(ApiEndpoints.logout);
      await TokenStorage.clearTokens();
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
