class MedicalReport {
  final String title;
  final String status;
  final String id;
  final String image;
  final String date;
  final String diagnosis;
  final String physician;
  final String diagnosisDate;
  final String symptoms;
  final String medication;
  final String recommendations;
  final String oxygen;

  MedicalReport({
    required this.title,
    required this.status,
    required this.id,
    required this.image,
    required this.date,
    required this.diagnosis,
    required this.physician,
    required this.diagnosisDate,
    required this.symptoms,
    required this.medication,
    required this.recommendations,
    required this.oxygen,
  });
}
