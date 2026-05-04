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
      pictureUrl: resolveImageUrl(json['pictureUrl']?.toString()), // null if localhost
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
