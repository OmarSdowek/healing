import 'dart:convert';
import '../network/token_storage.dart';

class JwtHelper {
  /// Extract doctor_id from JWT token
  static Future<int> getDoctorId() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) return 0;
      final parts = token.split('.');
      if (parts.length != 3) return 0;
      final decoded = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payload = jsonDecode(decoded) as Map<String, dynamic>;
      return int.tryParse(payload['doctor_id']?.toString() ?? '0') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Extract patient_id from JWT token
  static Future<int> getPatientId() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) return 0;
      final parts = token.split('.');
      if (parts.length != 3) return 0;
      final decoded = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payload = jsonDecode(decoded) as Map<String, dynamic>;
      return int.tryParse(payload['patient_id']?.toString() ?? '0') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Extract full name from JWT token
  static Future<String?> getFullName() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) return null;
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final decoded = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payload = jsonDecode(decoded) as Map<String, dynamic>;
      return payload[
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
          ?.toString();
    } catch (_) {
      return null;
    }
  }
}
