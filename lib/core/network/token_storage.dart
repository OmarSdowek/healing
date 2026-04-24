import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _doctorIdKey = "doctor_id";

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? doctorId,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
    if (doctorId != null) {
      await _storage.write(key: _doctorIdKey, value: doctorId);
    }
  }

  static Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessKey);

  static Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshKey);

  static Future<String?> getDoctorId() async =>
      await _storage.read(key: _doctorIdKey);

  static Future<void> clearTokens() async => await _storage.deleteAll();
}
