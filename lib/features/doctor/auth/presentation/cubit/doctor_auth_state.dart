part of 'doctor_auth_cubit.dart';

abstract class DoctorAuthState {
  const DoctorAuthState();
}

class DoctorAuthInitial extends DoctorAuthState {
  const DoctorAuthInitial();
}

class DoctorAuthLoading extends DoctorAuthState {
  const DoctorAuthLoading();
}

class DoctorAuthSuccess extends DoctorAuthState {
  final String doctorId;

  const DoctorAuthSuccess(this.doctorId);
}

class DoctorAuthError extends DoctorAuthState {
  final String message;

  const DoctorAuthError(this.message);
}

class DoctorLogoutSuccess extends DoctorAuthState {
  const DoctorLogoutSuccess();
}
