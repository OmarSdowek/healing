part of 'appointment_cubit.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentCancelling extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;

  AppointmentLoaded(this.appointments);
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);
}

class AppointmentCancelSuccess extends AppointmentState {}
