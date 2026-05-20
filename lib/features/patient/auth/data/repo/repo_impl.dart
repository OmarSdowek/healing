import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/features/patient/auth/data/model/auth_response_model.dart';
import 'package:healing/features/patient/auth/data/model/delete_requset_model.dart';
import 'package:healing/features/patient/auth/data/model/me_data_model.dart';
import 'package:healing/features/patient/auth/data/model/reset_password_request_model.dart';
import 'package:healing/features/patient/auth/domin/repo/auth_repo_interface.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/network/token_storage.dart';
import '../model/forget_request_model.dart';
import '../model/login_request_model.dart';
import '../model/register_request_model.dart';

class RepoImpl implements AuthRepoInterface {
  final ApiService _api;

  RepoImpl(this._api);
  @override
  Future<Either<Failure, AuthResponseModel>> register(
    RegisterRequestModel registerRequestModel,
  ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.patientRegister,
        data: registerRequestModel.toJson(),
      );

      final auth = AuthResponseModel.fromJson(response.data);

      return Right(auth);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> login(
    LoginRequestModel loginRequestModel,
  ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.patientLogin,
        data: loginRequestModel.toJson(),
      );

      final auth = AuthResponseModel.fromJson(response.data);

      // Clear old tokens first to avoid stale doctor_id
      await TokenStorage.clearTokens();

      await TokenStorage.saveTokens(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
      );

      return Right(auth);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail(String token) async {
    try {
      await _api.get(
        ApiEndpoints.patientVerifyEmail,
        queryParameters: {'token': token},
      );

      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword(
      ForgetRequestModel forgetRequestModel,
      ) async {
    try {
      await _api.post(
        ApiEndpoints.patientForgotPassword,
        data: forgetRequestModel.toJson(),
      );

      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      print("🔥 RepoImpl: logout() called");
      
      final refreshToken = await TokenStorage.getRefreshToken();
      
      await _api.post(
        ApiEndpoints.patientLogOut,
        data: {'refreshToken': refreshToken},
      );

      // ✅ Clear tokens after successful logout
      await TokenStorage.clearTokens();
      print("✅ Tokens cleared successfully");

      return const Right(unit);
    } on DioException catch (e) {
      print("❌ Logout API failed: ${e.message}");
      // Even if API fails, clear tokens locally
      await TokenStorage.clearTokens();
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      print("❌ Unexpected error in logout: $e");
      await TokenStorage.clearTokens();
      return Left(Failure("Logout failed: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(
      ResetPasswordRequestModel resetPasswordRequestModel,
      ) async {
    try {
      await _api.post(
        ApiEndpoints.patientSetNewPassword,
        data: resetPasswordRequestModel.toJson(),
      );

      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(
    DeleteRequsetModel deleteRequsetModel,
  ) async {
    try {
      print("🔥 RepoImpl: deleteAccount() called for user: ${deleteRequsetModel.userId}");
      
      await _api.delete(
        ApiEndpoints.patientLogin, // TODO: Update to correct delete endpoint
        queryParameters: deleteRequsetModel.toJson(),
      );

      // ✅ Clear tokens after successful account deletion
      await TokenStorage.clearTokens();
      print("✅ Account deleted and tokens cleared");

      return const Right(unit);
    } on DioException catch (e) {
      print("❌ Delete account API failed: ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      print("❌ Unexpected error in deleteAccount: $e");
      return Left(Failure("Delete account failed: $e"));
    }
  }

  @override
  Future<Either<Failure, MeDataModel>> meData() async {    try {
      print("🔥 RepoImpl: meData() called");
      final response = await _api.get(ApiEndpoints.patientMe);

      print("🔥 RepoImpl: API Response received");
      print("🔥 Response data type: ${response.data.runtimeType}");
      print("🔥 Response data: ${response.data}");

      // Handle both wrapped and unwrapped responses
      final Map<String, dynamic> jsonData;
      
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        
        // Check if response is wrapped in {data: {...}}
        if (responseMap.containsKey('data') && responseMap['data'] is Map<String, dynamic>) {
          jsonData = responseMap['data'] as Map<String, dynamic>;
          print("🔥 Using wrapped data from response.data.data");
        } else {
          jsonData = responseMap;
          print("🔥 Using direct response.data");
        }
      } else {
        print("❌ Unexpected response type: ${response.data.runtimeType}");
        return Left(Failure("Invalid response format"));
      }

      print("🔥 Parsing JSON: $jsonData");
      final model = MeDataModel.fromJson(jsonData);
      print("✅ MeDataModel parsed successfully: ${model.fullName}");

      return Right(model);
    } on DioException catch (e) {
      print("❌ DioException in meData: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e, stackTrace) {
      print("❌ Unexpected error in meData: $e");
      print("❌ StackTrace: $stackTrace");
      return Left(Failure("Failed to load profile data: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _api.post(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
