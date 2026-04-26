class DoctorLoginRequest {
  final String email;
  final String password;

  DoctorLoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
