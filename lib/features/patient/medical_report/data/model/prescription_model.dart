import '../../../../../core/helper/image_helper.dart';
import '../../domin/entity/prescription_entity.dart';

class PrescriptionModel extends PrescriptionEntity {
  PrescriptionModel({
    required super.id,
    required super.status,
    required super.dateOfIssue,
    required super.doctor,
    required super.medications,
    required super.doctorNotes,
    super.downloadPdfUrl,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    // ── Flat API format ────────────────────────────────────────────────────
    // { id, medicationName, dosage, frequency, durationDays, instructions,
    //   status, prescribedAt, expiresAt, doctorId, ... }
    final isFlatFormat =
        json.containsKey('medicationName') || json.containsKey('prescribedAt');

    if (isFlatFormat) {
      final rawDoctorName = json['doctorName']?.toString();
      final doctorId = (json['doctorId'] as num?)?.toInt() ?? 0;
      // doctorName is null in the API response — repo will enrich it later
      final doctorName = (rawDoctorName != null && rawDoctorName.isNotEmpty)
          ? rawDoctorName
          : 'Doctor #$doctorId';

      final medicationName = json['medicationName']?.toString() ?? '';
      final dosage = json['dosage']?.toString() ?? '';
      final frequency = json['frequency']?.toString() ?? '';
      final durationDays = (json['durationDays'] as num?)?.toInt() ?? 0;
      final instructions = json['instructions']?.toString() ?? '';
      final prescribedAt = json['prescribedAt']?.toString() ??
          json['createdAt']?.toString() ??
          '';

      return PrescriptionModel(
        id: json['id']?.toString() ?? '',
        status: json['status']?.toString() ?? 'Active',
        dateOfIssue: prescribedAt.length >= 10
            ? prescribedAt.substring(0, 10)
            : prescribedAt,
        doctor: PrescriptionDoctorModel(
          id: doctorId,
          name: doctorName,
          specialization: json['doctorSpecialization']?.toString() ?? '',
          pictureUrl: null,
        ),
        medications: [
          MedicationModel(
            name: medicationName,
            dosage: dosage,
            form: frequency,
            durationDays: durationDays,
            instructions: instructions.isNotEmpty
                ? instructions
                : 'No special instructions',
          ),
        ],
        doctorNotes: instructions,
        downloadPdfUrl: null,
      );
    }

    // ── Old nested format ──────────────────────────────────────────────────
    final doctorJson = json['doctor'] as Map<String, dynamic>? ?? {};
    final medsJson = json['medications'] as List<dynamic>? ?? [];

    return PrescriptionModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      dateOfIssue: json['dateOfIssue']?.toString() ?? '',
      doctor: PrescriptionDoctorModel.fromJson(doctorJson),
      medications: medsJson
          .map((e) => MedicationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      doctorNotes: json['doctorNotes']?.toString() ?? '',
      downloadPdfUrl: json['downloadPdfUrl']?.toString(),
    );
  }
}

class PrescriptionDoctorModel extends PrescriptionDoctorEntity {
  PrescriptionDoctorModel({
    required super.id,
    required super.name,
    required super.specialization,
    super.pictureUrl,
  });

  factory PrescriptionDoctorModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionDoctorModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      specialization: json['specialization']?.toString() ?? '',
      pictureUrl: resolveImageUrl(json['pictureUrl']?.toString()),
    );
  }
}

class MedicationModel extends MedicationEntity {
  MedicationModel({
    required super.name,
    required super.dosage,
    required super.form,
    required super.durationDays,
    required super.instructions,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      name: json['name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      form: json['form']?.toString() ?? '',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 0,
      instructions: json['instructions']?.toString() ?? '',
    );
  }
}
