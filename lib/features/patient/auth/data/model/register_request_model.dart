class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;
  final PatientInfoModel patientInfo;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
    required this.patientInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "role": role,
      "patientInfo": patientInfo.toJson(),
    };
  }
}
class PatientInfoModel {
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String nationalId;
  final AddressModel address;

  PatientInfoModel({
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.nationalId,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "nationalId": nationalId,
      "address": address.toJson(),
    };
  }
}
class AddressModel {
  final String street;
  final String city;
  final String country;
  final String postalCode;

  AddressModel({
    required this.street,
    required this.city,
    required this.country,
    required this.postalCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "street": street,
      "city": city,
      "country": country,
      "postalCode": postalCode,
    };
  }
}