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

class DoctorAuthError extends DoctorAuthState {
  final String message;
  const DoctorAuthError(this.message);
}

// ── Success states ────────────────────────────────────────────────────────────

class DoctorLoginSuccess extends DoctorAuthState {
  final String doctorId;
  const DoctorLoginSuccess(this.doctorId);
}

class DoctorRegisterSuccess extends DoctorAuthState {
  final String email;
  final String emailVerificationToken;
  const DoctorRegisterSuccess({
    required this.email,
    required this.emailVerificationToken,
  });
}

class DoctorEmailVerifiedSuccess extends DoctorAuthState {
  const DoctorEmailVerifiedSuccess();
}

class DoctorForgotPasswordSent extends DoctorAuthState {
  const DoctorForgotPasswordSent();
}

class DoctorPasswordResetSuccess extends DoctorAuthState {
  const DoctorPasswordResetSuccess();
}

class DoctorLogoutSuccess extends DoctorAuthState {
  const DoctorLogoutSuccess();
}

class DoctorPasswordChanged extends DoctorAuthState {
  const DoctorPasswordChanged();
}
