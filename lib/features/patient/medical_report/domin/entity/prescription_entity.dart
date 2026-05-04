class PrescriptionEntity {
  final String id;
  final String status;
  final String dateOfIssue;
  final PrescriptionDoctorEntity doctor;
  final List<MedicationEntity> medications;
  final String doctorNotes;
  final String? downloadPdfUrl;

  PrescriptionEntity({
    required this.id,
    required this.status,
    required this.dateOfIssue,
    required this.doctor,
    required this.medications,
    required this.doctorNotes,
    this.downloadPdfUrl,
  });
}

class PrescriptionDoctorEntity {
  final int id;
  final String name;
  final String specialization;
  final String? pictureUrl;

  PrescriptionDoctorEntity({
    required this.id,
    required this.name,
    required this.specialization,
    this.pictureUrl,
  });
}

class MedicationEntity {
  final String name;
  final String dosage;
  final String form;
  final int durationDays;
  final String instructions;

  MedicationEntity({
    required this.name,
    required this.dosage,
    required this.form,
    required this.durationDays,
    required this.instructions,
  });
}
