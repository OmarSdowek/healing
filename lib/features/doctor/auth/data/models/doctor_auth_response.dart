import 'dart:convert';
import '../../domain/entities/doctor_user.dart';

class DoctorAuthResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final DoctorUser user;
  final String? emailVerificationToken;

  DoctorAuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
    this.emailVerificationToken,
  });

  factory DoctorAuthResponse.fromJson(Map<String, dynamic> json) {
    // Extract doctor_id from JWT access token
    String? doctorId;
    try {
      final token = json['accessToken'] as String? ?? '';
      if (token.isNotEmpty) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final decoded = utf8.decode(
            base64Url.decode(base64Url.normalize(parts[1])),
          );
          final payload = jsonDecode(decoded) as Map<String, dynamic>;
          doctorId = payload['doctor_id']?.toString();
        }
      }
    } catch (_) {}

    final userData = json['user'] as Map<String, dynamic>? ?? {};

    return DoctorAuthResponse(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as int? ?? 0,
      user: DoctorUser.fromJson({...userData, 'doctorId': doctorId}),
      emailVerificationToken:
          json['emailVerificationToken'] as String?,
    );
  }
}
