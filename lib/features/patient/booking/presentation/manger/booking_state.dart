part of 'booking_cubit.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingDoctorsLoading extends BookingState {}

class BookingDoctorsLoaded extends BookingState {
  final List<DoctorEntity> doctors;
  BookingDoctorsLoaded(this.doctors);
}

class BookingSlotsLoading extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSlotsLoaded extends BookingState {
  final List<TimeSlotEntity> slots;
  BookingSlotsLoaded(this.slots);
}

class BookingSuccess extends BookingState {
  final AppointmentEntity appointment;
  BookingSuccess(this.appointment);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
