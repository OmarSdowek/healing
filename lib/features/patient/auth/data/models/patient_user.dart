class PatientUser {
  final String? patientId;
  final String? name;
  final String? email;
  final String? phone;

  PatientUser({this.patientId, this.name, this.email, this.phone});

  factory PatientUser.fromJson(Map<String, dynamic> json) {
    return PatientUser(
      patientId: json['patientId']?.toString(),
      name: json['fullName'] ?? json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'patientId': patientId,
    'name': name,
    'email': email,
    'phone': phone,
  };
}
