class PatientLoginRequest {
  final String email;
  final String password;

  PatientLoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
