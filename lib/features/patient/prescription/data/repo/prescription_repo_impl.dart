import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../medical_report/data/model/prescription_model.dart';
import '../../../medical_report/domin/entity/prescription_entity.dart';
import '../../domin/repo/prescription_repo_interface.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final ApiService _api;

  PrescriptionRepositoryImpl(this._api);

  // ─── GET /api/patients/{patientId}/prescriptions/active ──────────────────
  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getActivePrescriptions(
      int patientId) async {
    try {
      final response =
          await _api.get(ApiEndpoints.getActivePrescriptions(patientId));
      final prescriptions = _parse(response.data);
      return Right(await _enrichWithDoctorInfo(prescriptions));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/patients/{patientId}/prescriptions ─────────────────────────
  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getAllPrescriptions(
      int patientId) async {
    try {
      final response =
          await _api.get(ApiEndpoints.getPrescriptions(patientId));
      final prescriptions = _parse(response.data);
      return Right(await _enrichWithDoctorInfo(prescriptions));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── GET /api/patients/{patientId}/prescriptions/{id}/pdf ────────────────
  @override
  Future<Either<Failure, String>> downloadPrescriptionPdf({
    required int patientId,
    required String prescriptionId,
  }) async {
    try {
      final bytes = await _api.downloadBytes(
        ApiEndpoints.downloadPrescriptionPdf(patientId, prescriptionId),
      );

      // Save to app's documents directory
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/prescription_$prescriptionId.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      return Right(filePath);
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  // ─── Fetch doctor info and merge into prescriptions ──────────────────────
  /// Collects unique doctorIds from the list, fetches each doctor once,
  /// then rebuilds each prescription with the real name/specialization/picture.
  Future<List<PrescriptionEntity>> _enrichWithDoctorInfo(
      List<PrescriptionEntity> prescriptions) async {
    // Collect unique doctor IDs that still have no real name
    final missingIds = prescriptions
        .where((p) => p.doctor.name.startsWith('Doctor #'))
        .map((p) => p.doctor.id)
        .toSet();

    if (missingIds.isEmpty) return prescriptions;

    // Fetch each doctor once (parallel)
    final doctorMap = <int, PrescriptionDoctorModel>{};
    await Future.wait(missingIds.map((id) async {
      try {
        final res = await _api.get(ApiEndpoints.getDoctorById(id));
        final data = res.data is Map
            ? res.data as Map<String, dynamic>
            : (res.data?['data'] ?? res.data?['doctor']) as Map<String, dynamic>?;

        if (data != null) {
          final fullName = data['fullName']?.toString() ??
              '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
          final specialization = data['specialization']?.toString() ?? '';
          final pictureUrl = data['pictureUrl']?.toString();

          doctorMap[id] = PrescriptionDoctorModel(
            id: id,
            name: fullName.isNotEmpty ? fullName : 'Doctor #$id',
            specialization: specialization,
            pictureUrl: pictureUrl,
          );
        }
      } on DioException catch (e) {
        debugPrint('⚠️ Could not fetch doctor $id: ${e.message}');
      }
    }));

    // Rebuild prescriptions with enriched doctor info
    return prescriptions.map((p) {
      final enriched = doctorMap[p.doctor.id];
      if (enriched == null) return p;
      return PrescriptionModel(
        id: p.id,
        status: p.status,
        dateOfIssue: p.dateOfIssue,
        doctor: enriched,
        medications: p.medications,
        doctorNotes: p.doctorNotes,
        downloadPdfUrl: p.downloadPdfUrl,
      );
    }).toList();
  }

  List<PrescriptionEntity> _parse(dynamic raw) {
    final List<dynamic> data;
    if (raw is Map) {
      data = (raw['data'] ?? raw['items'] ?? []) as List;
    } else if (raw is List) {
      data = raw;
    } else {
      data = [];
    }
    return data.map((e) => PrescriptionModel.fromJson(e)).toList();
  }
}
