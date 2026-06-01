import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/doctor_auth_response.dart';
import '../../data/models/doctor_login_request.dart';
import '../../data/models/doctor_register_request.dart';

abstract class DoctorAuthRepository {
  Future<Either<Failure, DoctorAuthResponse>> login(DoctorLoginRequest request);
  Future<Either<Failure, DoctorAuthResponse>> register(DoctorRegisterRequest request);
  Future<Either<Failure, Unit>> verifyEmail(String token);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, Unit>> forgotPassword(String email);
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
