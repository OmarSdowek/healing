class DoctorAuthResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final DoctorUserInfo user;

  DoctorAuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory DoctorAuthResponse.fromJson(Map<String, dynamic> json) =>
      DoctorAuthResponse(
        accessToken: json["accessToken"] ?? "",
        refreshToken: json["refreshToken"] ?? "",
        expiresIn: json["expiresIn"] ?? 0,
        user: DoctorUserInfo.fromJson(json["user"] ?? {}),
      );
}

class DoctorUserInfo {
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final String? doctorId;

  DoctorUserInfo({
    required this.id,
    required this.email,
    required this.fullName,
    required this.roles,
    this.doctorId,
  });

  factory DoctorUserInfo.fromJson(Map<String, dynamic> json) => DoctorUserInfo(
    id: json["id"] ?? "",
    email: json["email"] ?? "",
    fullName: json["fullName"] ?? "",
    roles: List<String>.from(json["roles"] ?? []),
    doctorId: json["doctor_id"]?.toString(),
  );
}
