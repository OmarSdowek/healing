class MedicalRecordEntity {
  final int id;
  final int patientId;
  final int doctorId;
  final String visitDate;
  final String chiefComplaint;
  final String diagnosis;
  final String? clinicalNotes;
  final String? treatmentPlan;
  final String? followUpDate;

  MedicalRecordEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.visitDate,
    required this.chiefComplaint,
    required this.diagnosis,
    this.clinicalNotes,
    this.treatmentPlan,
    this.followUpDate,
  });
}

class PatientDetailsEntity {
  final int id;
  final String fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? phone;
  final String? bloodType;
  final String? medicalRecordNumber;
  final List<String> allergies;
  final List<String> medicalHistories;

  PatientDetailsEntity({
    required this.id,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.bloodType,
    this.medicalRecordNumber,
    this.allergies = const [],
    this.medicalHistories = const [],
  });
}
