import '../../domain/entities/doctor_profile_entity.dart';

class DoctorProfileModel extends DoctorProfileEntity {
  DoctorProfileModel({
    String? doctorId,
    String? fullName,
    String? email,
    String? phone,
    String? specialization,
    String? bio,
    String? profileImage,
    double? rating,
    int? yearsOfExperience,
    String? licenseNumber,
    List<String>? qualifications,
  }) : super(
         doctorId: doctorId,
    fullName: fullName,
         email: email,
         phone: phone,
         specialization: specialization,
         bio: bio,
         profileImage: profileImage,
         rating: rating,
         yearsOfExperience: yearsOfExperience,
         licenseNumber: licenseNumber,
         qualifications: qualifications,
       );

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle both /api/Auth/me and /api/doctors/{id}/details responses
    final name = json['fullName'] ??
        json['name'] ??
        '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim();

    return DoctorProfileModel(
      doctorId: (json['doctorId'] ?? json['id'])?.toString(),
      fullName: name.isEmpty ? null : name,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      specialization: json['specialization']?.toString(),
      bio: json['bio']?.toString(),
      profileImage: json['pictureUrl']?.toString() ??
          json['profileImage']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      yearsOfExperience:
          ((json['yearsOfExperience']) as num?)?.toInt(),
      licenseNumber: json['licenseNumber']?.toString(),
      qualifications: (json['qualifications'] as List?)
              ?.map((q) =>
                  (q['degree'] ?? q['title'] ?? q.toString()).toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'doctorId': doctorId,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'specialization': specialization,
    'bio': bio,
    'profileImage': profileImage,
    'rating': rating,
    'yearsOfExperience': yearsOfExperience,
    'licenseNumber': licenseNumber,
    'qualifications': qualifications,
  };
}
