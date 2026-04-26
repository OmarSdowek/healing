import '../../domain/entities/doctor_profile_entity.dart';

class DoctorProfileModel extends DoctorProfileEntity {
  DoctorProfileModel({
    String? doctorId,
    String? name,
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
         name: name,
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
    return DoctorProfileModel(
      doctorId: json['doctorId']?.toString(),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      specialization: json['specialization'],
      bio: json['bio'],
      profileImage: json['profileImage'],
      rating: (json['rating'] as num?)?.toDouble(),
      yearsOfExperience: json['yearsOfExperience'],
      licenseNumber: json['licenseNumber'],
      qualifications: List<String>.from(json['qualifications'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'doctorId': doctorId,
    'name': name,
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
