import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/patient_auth_response.dart';
import '../../data/models/patient_login_request.dart';

abstract class PatientAuthRepository {
  Future<Either<Failure, PatientAuthResponse>> login(
    PatientLoginRequest request,
  );
  Future<Either<Failure, Unit>> logout();
}
