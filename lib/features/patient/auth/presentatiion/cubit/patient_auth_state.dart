part of 'patient_auth_cubit.dart';

abstract class PatientAuthState {
  const PatientAuthState();
}

class PatientAuthInitial extends PatientAuthState {
  const PatientAuthInitial();
}

class PatientAuthLoading extends PatientAuthState {
  const PatientAuthLoading();
}

class PatientAuthSuccess extends PatientAuthState {
  final PatientAuthResponse auth;

  const PatientAuthSuccess(this.auth);
}

class PatientAuthError extends PatientAuthState {
  final String message;

  const PatientAuthError(this.message);
}
