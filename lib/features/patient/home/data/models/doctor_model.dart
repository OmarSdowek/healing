import '../../domin/entity/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
    required super.id,
    required super.fullName,
    required super.specialization,
    required super.departmentId,
    required super.departmentName,
    required super.yearsOfExperience,
    required super.consultationFee,
    required super.pictureUrl,
    super.status,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: json['fullName']?.toString() ??
          '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      specialization: json['specialization']?.toString() ?? "",
      departmentId: (json['departmentId'] as num?)?.toInt() ?? 0,
      departmentName: json['departmentName']?.toString() ?? "",
      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt() ?? 0,
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ??
          (json['ConsultationFee'] as num?)?.toDouble() ??
          (json['fee'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      pictureUrl: json['pictureUrl']?.toString() ?? "",
      status: json['status']?.toString(),
    );
  }
}