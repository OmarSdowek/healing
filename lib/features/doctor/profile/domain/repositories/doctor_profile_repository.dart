import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/doctor_profile_entity.dart';

abstract class DoctorProfileRepository {
  Future<Either<Failure, DoctorProfileEntity>> getProfile();
  Future<Either<Failure, Unit>> updateProfile(DoctorProfileEntity profile);
  Future<Either<Failure, Unit>> updateProfileImage(String imagePath);
}
