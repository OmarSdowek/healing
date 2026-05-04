part of 'doctor_profile_cubit.dart';

abstract class DoctorProfileState {
  const DoctorProfileState();
}

class DoctorProfileInitial extends DoctorProfileState {
  const DoctorProfileInitial();
}

class DoctorProfileLoading extends DoctorProfileState {
  const DoctorProfileLoading();
}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorProfileEntity profile;

  const DoctorProfileLoaded(this.profile);
}

class DoctorProfileUpdating extends DoctorProfileState {
  const DoctorProfileUpdating();
}

class DoctorProfileUpdateSuccess extends DoctorProfileState {
  const DoctorProfileUpdateSuccess();
}

class DoctorProfileError extends DoctorProfileState {
  final String message;

  const DoctorProfileError(this.message);
}
