import 'dart:convert';
import '../../domain/entities/doctor_user.dart';

class DoctorAuthResponse {
  final String accessToken;
  final String refreshToken;
  final DoctorUser user;

  DoctorAuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory DoctorAuthResponse.fromJson(Map<String, dynamic> json) {
    // Extract doctor ID from JWT token
    String? doctorId;
    try {
      final token = json['accessToken'] ?? '';
      if (token.isNotEmpty) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final decoded = utf8.decode(
            base64Url.decode(base64Url.normalize(parts[1])),
          );
          final payload = jsonDecode(decoded);
          doctorId = payload['doctor_id']?.toString();
        }
      }
    } catch (e) {
      // If JWT parsing fails, continue without doctor ID
    }

    final userData = json['user'] ?? {};
    return DoctorAuthResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: DoctorUser.fromJson({...userData, 'doctorId': doctorId}),
    );
  }
}
