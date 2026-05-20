import 'package:dartz/dartz.dart';
import 'package:healing/features/patient/auth/data/model/me_data_model.dart';
import '../../../../../core/error/failure.dart';
import '../../data/model/auth_response_model.dart';
import '../../data/model/delete_requset_model.dart';
import '../../data/model/forget_request_model.dart';
import '../../data/model/login_request_model.dart';
import '../../data/model/register_request_model.dart';
import '../../data/model/reset_password_request_model.dart';

abstract class AuthRepoInterface {
  Future<Either<Failure, AuthResponseModel>> register(
    RegisterRequestModel registerRequestModel,
  );

  Future<Either<Failure, AuthResponseModel>> login(
    LoginRequestModel loginRequestModel,
  );

  Future<Either<Failure, Unit>> verifyEmail(String token);

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> forgotPassword(
    ForgetRequestModel forgetRequestModel,
  );

  Future<Either<Failure, Unit>> resetPassword(
    ResetPasswordRequestModel resetPasswordRequestModel,
  );

  Future<Either<Failure, void>> deleteAccount(DeleteRequsetModel deleteRequsetModel);

  Future<Either<Failure, MeDataModel>> meData();

  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
