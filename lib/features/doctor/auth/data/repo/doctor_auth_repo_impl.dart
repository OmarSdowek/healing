import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:healing/core/constant/api_endpoint.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/network/error_handling.dart';
import 'package:healing/core/network/token_storage.dart';
import 'package:healing/features/doctor/auth/data/models/doctor_auth_response.dart';
import 'package:healing/features/doctor/auth/data/models/doctor_login_request.dart';
import 'package:healing/features/doctor/auth/domin/repo/doctor_auth_repo.dart';

class DoctorAuthRepoImpl implements DoctorAuthRepo {
  final ApiService _api;

  DoctorAuthRepoImpl(this._api);

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
