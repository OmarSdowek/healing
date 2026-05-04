part of 'doctor_home_cubit.dart';

abstract class DoctorHomeState {
  const DoctorHomeState();
}

class DoctorHomeInitial extends DoctorHomeState {
  const DoctorHomeInitial();
}

class DoctorHomeLoading extends DoctorHomeState {
  const DoctorHomeLoading();
}

class DoctorHomeLoaded extends DoctorHomeState {
  final DoctorDashboardEntity dashboard;

  const DoctorHomeLoaded(this.dashboard);
}

class DoctorHomeError extends DoctorHomeState {
  final String message;

  const DoctorHomeError(this.message);
}
