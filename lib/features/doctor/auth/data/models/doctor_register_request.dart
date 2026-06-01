/// Doctor self-registration request.
/// The doctor receives their doctorId via email from the SuperAdmin.
/// They use it here to link their identity account to their doctor profile.
class DoctorRegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final int doctorId;
  final String role;

  DoctorRegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.doctorId,
    this.role = 'Doctor',
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
        'doctorId': doctorId,
      };
}
