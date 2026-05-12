import '../../../../../core/helper/image_helper.dart';
import '../../domin/entity/medical_report_entity.dart';

class MedicalReportModel extends MedicalReportEntity {
  MedicalReportModel({
    required super.id,
    required super.type,
    required super.title,
    required super.date,
    required super.status,
    super.doctorName,
    super.thumbnailUrl,
  });

  factory MedicalReportModel.fromJson(Map<String, dynamic> json) {
    final rawThumb = json['thumbnailUrl']?.toString() ??
        json['imageUrl']?.toString();

    // Real API format: { id, chiefComplaint, diagnosis, visitDate, doctorName, ... }
    final rawDate = json['visitDate']?.toString() ??
        json['date']?.toString() ?? '';
    final date = rawDate.length >= 10 ? rawDate.substring(0, 10) : rawDate;

    final diagnosis = json['diagnosis']?.toString() ??
        json['title']?.toString() ?? 'Medical Record';
    final chiefComplaint = json['chiefComplaint']?.toString() ??
        json['type']?.toString() ?? '';
    final rawDoctorName = json['doctorName']?.toString() ?? '';

    return MedicalReportModel(
      id: (json['id'] ?? json['Id'])?.toString() ?? '',
      type: chiefComplaint,
      title: diagnosis,
      date: date,
      status: 'Completed',
      doctorName: rawDoctorName.isNotEmpty ? rawDoctorName : null,
      thumbnailUrl: resolveImageUrl(rawThumb),
    );
  }
}

class MedicalReportDetailModel extends MedicalReportDetailEntity {
  MedicalReportDetailModel({
    required super.id,
    required super.type,
    required super.title,
    required super.status,
    required super.date,
    required super.treatingPhysician,
    required super.dateOfDiagnosis,
    required super.symptoms,
    required super.prescribedMedication,
    required super.doctorRecommendations,
    required super.metrics,
    super.reportImageUrl,
    super.downloadPdfUrl,
  });

  factory MedicalReportDetailModel.fromJson(Map<String, dynamic> json) {
    final details = json['reportDetails'] as Map<String, dynamic>? ?? {};

    final symptoms = (details['symptoms'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final meds = (details['prescribedMedication'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final metrics = (details['metrics'] as List<dynamic>? ?? [])
        .map((e) => MetricModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Resolve image URL — null if localhost
    final rawImage = json['reportImageUrl']?.toString();

    return MedicalReportDetailModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      treatingPhysician: json['treatingPhysician']?.toString() ?? '',
      dateOfDiagnosis: json['dateOfDiagnosis']?.toString() ?? '',
      symptoms: symptoms,
      prescribedMedication: meds,
      doctorRecommendations:
          details['doctorRecommendations']?.toString() ?? '',
      metrics: metrics,
      reportImageUrl: resolveImageUrl(rawImage), // null if localhost
      downloadPdfUrl: json['downloadPdfUrl']?.toString(),
    );
  }
}

class MetricModel extends MetricEntity {
  MetricModel({
    required super.name,
    required super.value,
    required super.unit,
    required super.status,
    required super.range,
  });

  factory MetricModel.fromJson(Map<String, dynamic> json) {
    return MetricModel(
      name: json['name']?.toString() ?? '',
      value: (json['value'] as num?) ?? 0,
      unit: json['unit']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      range: json['range']?.toString() ?? '',
    );
  }
}
