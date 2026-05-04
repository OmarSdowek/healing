import 'package:healing/features/patient/auth/data/model/user-model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;
  final String? emailVerificationToken;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
    required this.emailVerificationToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as int? ?? 0,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      emailVerificationToken: json['emailVerificationToken'] as String?,
    );
  }
}