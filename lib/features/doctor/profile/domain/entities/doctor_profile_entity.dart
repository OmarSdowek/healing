class DoctorProfileEntity {
  final String? doctorId;
  final String? name;
  final String? email;
  final String? phone;
  final String? specialization;
  final String? bio;
  final String? profileImage;
  final double? rating;
  final int? yearsOfExperience;
  final String? licenseNumber;
  final List<String>? qualifications;

  DoctorProfileEntity({
    this.doctorId,
    this.name,
    this.email,
    this.phone,
    this.specialization,
    this.bio,
    this.profileImage,
    this.rating,
    this.yearsOfExperience,
    this.licenseNumber,
    this.qualifications,
  });
}
