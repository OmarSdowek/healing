class MedicalReportEntity {
  final String id;
  final String type;       // chiefComplaint
  final String title;      // diagnosis
  final String date;       // visitDate
  final String status;     // doctorName
  final String? doctorName;
  final String? thumbnailUrl;

  MedicalReportEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.status,
    this.doctorName,
    this.thumbnailUrl,
  });
}

class MedicalReportDetailEntity {
  final String id;
  final String type;
  final String title;
  final String status;
  final String date;
  final String treatingPhysician;
  final String dateOfDiagnosis;
  final List<String> symptoms;
  final List<String> prescribedMedication;
  final String doctorRecommendations;
  final List<MetricEntity> metrics;
  final String? reportImageUrl;
  final String? downloadPdfUrl;

  MedicalReportDetailEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    required this.date,
    required this.treatingPhysician,
    required this.dateOfDiagnosis,
    required this.symptoms,
    required this.prescribedMedication,
    required this.doctorRecommendations,
    required this.metrics,
    this.reportImageUrl,
    this.downloadPdfUrl,
  });
}

class MetricEntity {
  final String name;
  final num value;
  final String unit;
  final String status;
  final String range;

  MetricEntity({
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    required this.range,
  });
}
