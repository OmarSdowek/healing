class DoctorUser {
  final String? doctorId;
  final String? name;
  final String? email;
  final String? specialization;
  final String? phone;

  DoctorUser({
    this.doctorId,
    this.name,
    this.email,
    this.specialization,
    this.phone,
  });

  factory DoctorUser.fromJson(Map<String, dynamic> json) {
    return DoctorUser(
      doctorId: json['doctorId']?.toString(),
      name: json['name'],
      email: json['email'],
      specialization: json['specialization'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'doctorId': doctorId,
    'name': name,
    'email': email,
    'specialization': specialization,
    'phone': phone,
  };
}
