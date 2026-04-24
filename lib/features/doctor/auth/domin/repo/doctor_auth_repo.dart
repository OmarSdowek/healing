import 'package:dartz/dartz.dart';
import 'package:healing/core/error/failure.dart';
import 'package:healing/features/doctor/auth/data/models/doctor_auth_response.dart';
import 'package:healing/features/doctor/auth/data/models/doctor_login_request.dart';

abstract class DoctorAuthRepo {
  Future<Either<Failure, DoctorAuthResponse>> login(DoctorLoginRequest request);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, Unit>> forgotPassword(String email);
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  });
}
