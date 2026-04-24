part of 'doctor_appointments_cubit.dart';

abstract class DoctorAppointmentsState {}

class DoctorAppointmentsInitial extends DoctorAppointmentsState {}

class DoctorAppointmentsLoading extends DoctorAppointmentsState {}

class DoctorAppointmentsLoaded extends DoctorAppointmentsState {
  final List<AppointmentModel> appointments;
  DoctorAppointmentsLoaded(this.appointments);
}

class DoctorAppointmentActionSuccess extends DoctorAppointmentsState {
  final AppointmentModel appointment;
  DoctorAppointmentActionSuccess(this.appointment);
}

class DoctorAppointmentsError extends DoctorAppointmentsState {
  final String message;
  DoctorAppointmentsError(this.message);
}
