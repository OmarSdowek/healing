import '../../../../../core/utils/blood_type_formatter.dart';
import '../../domain/entities/medical_record_entity.dart';

/// Responsible only for transforming raw API JSON → domain entities.
class MedicalRecordMapper {
  MedicalRecordMapper._();

  static MedicalRecordEntity toEntity(dynamic data) {
    final json = data as Map<String, dynamic>;
    return MedicalRecordEntity(
      id: ((json['id'] ?? json['Id']) as num?)?.toInt() ?? 0,
      patientId:
          ((json['patientId'] ?? json['PatientId']) as num?)?.toInt() ?? 0,
      doctorId:
          ((json['doctorId'] ?? json['DoctorId']) as num?)?.toInt() ?? 0,
      visitDate: (json['visitDate'] ?? json['VisitDate'])?.toString() ?? '',
      chiefComplaint:
          (json['chiefComplaint'] ?? json['ChiefComplaint'])?.toString() ?? '',
      diagnosis: (json['diagnosis'] ?? json['Diagnosis'])?.toString() ?? '',
      clinicalNotes:
          (json['clinicalNotes'] ?? json['ClinicalNotes'])?.toString(),
      treatmentPlan:
          (json['treatmentPlan'] ?? json['TreatmentPlan'])?.toString(),
      followUpDate:
          (json['followUpDate'] ?? json['FollowUpDate'])?.toString(),
    );
  }

  static PatientDetailsEntity toPatientDetails(dynamic data) {
    final json = data as Map<String, dynamic>;

    final allergies = _extractAllergies(json);
    final histories = _extractHistories(json);
    final patient = json['patient'] ?? json['Patient'] ?? json;

    return PatientDetailsEntity(
      id: ((patient['id'] ?? patient['Id']) as num?)?.toInt() ?? 0,
      fullName: _extractFullName(patient),
      dateOfBirth:
          (patient['dateOfBirth'] ?? patient['DateOfBirth'])?.toString(),
      gender: (patient['gender'] ?? patient['Gender'])?.toString(),
      phone: (patient['phone'] ?? patient['Phone'])?.toString(),
      bloodType: BloodTypeFormatter.format(
        (patient['bloodType'] ?? patient['BloodType'])?.toString(),
      ),
      medicalRecordNumber: (patient['medicalRecordNumber'] ??
              patient['MedicalRecordNumber'])
          ?.toString(),
      allergies: allergies,
      medicalHistories: histories,
    );
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  static String _extractFullName(Map<String, dynamic> patient) {
    final full = patient['fullName'] ?? patient['FullName'];
    if (full != null && full.toString().trim().isNotEmpty) {
      return full.toString().trim();
    }
    final first =
        (patient['firstName'] ?? patient['FirstName'] ?? '').toString();
    final last =
        (patient['lastName'] ?? patient['LastName'] ?? '').toString();
    return '$first $last'.trim();
  }

  static List<String> _extractAllergies(Map<String, dynamic> json) {
    final raw = (json['allergies'] ?? json['Allergies'] ?? []) as List;
    return raw
        .map((a) => (a['allergen'] ??
                a['Allergen'] ??
                a['description'] ??
                a['Description'] ??
                a.toString())
            .toString())
        .toList();
  }

  static List<String> _extractHistories(Map<String, dynamic> json) {
    final raw =
        (json['medicalHistories'] ?? json['MedicalHistories'] ?? []) as List;
    return raw
        .map((h) =>
            (h['diagnosis'] ?? h['Diagnosis'] ?? h.toString()).toString())
        .toList();
  }
}
