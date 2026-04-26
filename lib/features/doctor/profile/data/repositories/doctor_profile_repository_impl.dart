import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/repositories/doctor_profile_repository.dart';
import '../models/doctor_profile_model.dart';

class DoctorProfileRepositoryImpl implements DoctorProfileRepository {
  final ApiService _api;

  DoctorProfileRepositoryImpl(this._api);

  @override
  Future<Either<Failure, DoctorProfileEntity>> getProfile() async {
    try {
      final response = await _api.get(ApiEndpoints.me);
      final profile = DoctorProfileModel.fromJson(response.data);
      return Right(profile);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(
    DoctorProfileEntity profile,
  ) async {
    try {
      await _api.put(
        ApiEndpoints.me,
        data: {
          'name': profile.name,
          'email': profile.email,
          'phone': profile.phone,
          'specialization': profile.specialization,
          'bio': profile.bio,
          'yearsOfExperience': profile.yearsOfExperience,
          'licenseNumber': profile.licenseNumber,
        },
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfileImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(imagePath),
      });

      await _api.post('${ApiEndpoints.me}/upload-image', data: formData);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}
