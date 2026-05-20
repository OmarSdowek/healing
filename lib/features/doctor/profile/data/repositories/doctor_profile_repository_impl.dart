import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../../../core/network/token_storage.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/repositories/doctor_profile_repository.dart';
import '../models/doctor_profile_model.dart';

class DoctorProfileRepositoryImpl implements DoctorProfileRepository {
  final ApiService _api;

  DoctorProfileRepositoryImpl(this._api);

  Future<String?> _getDoctorId() async {
    try {
      final token = await TokenStorage.getAccessToken();

      if (token != null && token.isNotEmpty) {
        final parts = token.split('.');

        if (parts.length == 3) {
          final decoded = utf8.decode(
            base64Url.decode(base64Url.normalize(parts[1])),
          );

          final payload = jsonDecode(decoded) as Map<String, dynamic>;

          final id = payload['doctor_id']?.toString();

          if (id != null && id.isNotEmpty) return id;
        }
      }
    } catch (_) {}

    return await TokenStorage.getDoctorId();
  }

  @override
  @override
  Future<Either<Failure, DoctorProfileEntity>> getProfile() async {
    try {
      final meResponse = await _api.get(ApiEndpoints.me);

      final meData = (meResponse.data['data'] ?? meResponse.data)
      as Map<String, dynamic>;

      final doctorId = meData['doctorId']?.toString();

      Map<String, dynamic> finalData = {...meData};

      if (doctorId != null) {
        try {
          final detailsResponse = await _api.get(
            ApiEndpoints.getDoctorDetails(int.parse(doctorId)),
          );

          final details = (detailsResponse.data['data'] ??
              detailsResponse.data) as Map<String, dynamic>;

          print("🔥 DETAILS RAW => $details");

          finalData.addAll(details);
        } catch (e) {
          print("DETAILS ERROR => $e");
        }
      }

      print("🔥 FINAL MERGED => $finalData");

      return Right(DoctorProfileModel.fromJson(finalData));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, Unit>> updateProfile(
      DoctorProfileEntity profile,
      ) async {
    try {
      final doctorId = await _getDoctorId();

      if (doctorId == null) {
        return Left(Failure('Doctor ID not found'));
      }

      await _api.put(
        ApiEndpoints.getDoctorById(int.parse(doctorId)),
        data: {
          if (profile.phone != null) 'phone': profile.phone,
          if (profile.bio != null) 'bio': profile.bio,
          if (profile.yearsOfExperience != null)
            'yearsOfExperience': profile.yearsOfExperience,
          if (profile.specialization != null)
            'specialization': profile.specialization,
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

      await _api.post(
        '${ApiEndpoints.me}/upload-image',
        data: formData,
      );

      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }
}