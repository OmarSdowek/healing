part of 'doctor_appointment_action_cubit.dart';

abstract class DoctorAppointmentActionState {}

class DoctorAppointmentActionInitial extends DoctorAppointmentActionState {}

class DoctorAppointmentActionLoading extends DoctorAppointmentActionState {}

class DoctorAppointmentActionSuccess extends DoctorAppointmentActionState {
  final String message;
  DoctorAppointmentActionSuccess(this.message);
}

class DoctorAppointmentActionError extends DoctorAppointmentActionState {
  final String message;
  DoctorAppointmentActionError(this.message);
}
