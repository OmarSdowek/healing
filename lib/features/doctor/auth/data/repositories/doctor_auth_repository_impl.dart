import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/network/token_storage.dart';
import '../../domain/repositories/doctor_auth_repository.dart';
import '../models/doctor_auth_response.dart';
import '../models/doctor_login_request.dart';

class DoctorAuthRepositoryImpl implements DoctorAuthRepository {
  final ApiService _api;

  DoctorAuthRepositoryImpl(this._api);

  @override
  Future<Either<Failure, DoctorAuthResponse>> login(
    DoctorLoginRequest request,
  ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final auth = DoctorAuthResponse.fromJson(response.data);

      // Save tokens and doctor ID
      await TokenStorage.saveTokens(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        doctorId: auth.user.doctorId,
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

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) async {
    try {
      await _api.post(ApiEndpoints.forgotPassword, data: {"email": email});
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _api.post(
        ApiEndpoints.resetPassword,
        data: {"token": token, "newPassword": newPassword},
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
