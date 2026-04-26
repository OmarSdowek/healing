import 'dart:convert';
import 'patient_user.dart';

class PatientAuthResponse {
  final String accessToken;
  final String refreshToken;
  final PatientUser user;

  PatientAuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory PatientAuthResponse.fromJson(Map<String, dynamic> json) {
    // Extract patient ID from JWT token
    String? patientId;
    try {
      final token = json['accessToken'] ?? '';
      if (token.isNotEmpty) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final decoded = utf8.decode(
            base64Url.decode(base64Url.normalize(parts[1])),
          );
          final payload = jsonDecode(decoded);
          patientId = payload['patient_id']?.toString();
        }
      }
    } catch (e) {
      // If JWT parsing fails, continue without patient ID
    }

    final userData = json['user'] ?? {};
    return PatientAuthResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: PatientUser.fromJson({...userData, 'patientId': patientId}),
    );
  }
}
