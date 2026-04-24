part of 'doctor_auth_cubit.dart';

abstract class DoctorAuthState {}

class DoctorAuthInitial extends DoctorAuthState {}

class DoctorAuthLoading extends DoctorAuthState {}

class DoctorAuthSuccess extends DoctorAuthState {
  final String doctorId;
  DoctorAuthSuccess(this.doctorId);
}

class DoctorForgotPasswordSent extends DoctorAuthState {}

class DoctorPasswordResetSuccess extends DoctorAuthState {}

class DoctorAuthError extends DoctorAuthState {
  final String message;
  DoctorAuthError(this.message);
}

class DoctorAuthLoggedOut extends DoctorAuthState {}
