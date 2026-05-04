class DoctorEntity {
  final int id;
  final String fullName;
  final String specialization;
  final int departmentId;
  final String departmentName;
  final int yearsOfExperience;
  final double consultationFee;
  final String pictureUrl;
  final String? status;

  DoctorEntity({
    required this.id,
    required this.fullName,
    required this.specialization,
    required this.departmentId,
    required this.departmentName,
    required this.yearsOfExperience,
    required this.consultationFee,
    required this.pictureUrl,
    this.status,
  });
}