part of 'patient_auth_cubit.dart';

abstract class PatientAuthState {}

class PatientAuthInitial extends PatientAuthState {}

class PatientAuthLoading extends PatientAuthState {}

class PatientAuthError extends PatientAuthState {
  final String message;
  PatientAuthError(this.message);
}

// ================= SUCCESS STATES =================

class PatientRegisterSuccess extends PatientAuthState {
  final String emailVerificationToken;
  final String email;

  PatientRegisterSuccess({
    required this.emailVerificationToken,
    required this.email,
  });
}

class PatientLoginSuccess extends PatientAuthState {
  final String userId;
  PatientLoginSuccess(this.userId);
}

class PatientEmailVerifiedSuccess extends PatientAuthState {}

class PatientForgotPasswordSent extends PatientAuthState {}

class PatientPasswordResetSuccess extends PatientAuthState {}
class PatientAccountDeletedSuccess extends PatientAuthState {}

class PatientDataSuccess extends PatientAuthState {
  final MeDataModel meData;
  PatientDataSuccess(this.meData);
}


class PatientLoggedOut extends PatientAuthState {}