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
    final name = (json['FullName'] ??
        json['fullName'] ??
        json['name'] ??
        '${json['FirstName'] ?? json['firstName'] ?? ''} '
            '${json['LastName'] ?? json['lastName'] ?? ''}')
        .toString()
        .trim();

    return DoctorProfileModel(
      doctorId: (json['doctorId'] ?? json['DoctorId'] ?? json['Id'] ?? json['id'])
          ?.toString(),

      fullName: name.isEmpty ? null : name,

      email: (json['Email'] ?? json['email'])?.toString(),
      phone: (json['Phone'] ?? json['phone'])?.toString(),

      specialization:
      (json['Specialization'] ?? json['specialization'])?.toString(),

      bio: (json['Bio'] ?? json['bio'])?.toString(),

      yearsOfExperience:
      (json['YearsOfExperience'] ?? json['yearsOfExperience']) as int?,

      licenseNumber:
      (json['LicenseNumber'] ?? json['licenseNumber'])?.toString(),

      profileImage:
      (json['PictureUrl'] ?? json['pictureUrl'])?.toString(),

      qualifications: (json['Qualifications'] as List?)
          ?.map((q) => q.toString())
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
