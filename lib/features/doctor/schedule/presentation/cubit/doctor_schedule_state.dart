part of 'doctor_schedule_cubit.dart';

abstract class DoctorScheduleState {
  const DoctorScheduleState();
}

class DoctorScheduleInitial extends DoctorScheduleState {
  const DoctorScheduleInitial();
}

class DoctorScheduleLoading extends DoctorScheduleState {
  const DoctorScheduleLoading();
}

class DoctorScheduleLoaded extends DoctorScheduleState {
  final List<DoctorScheduleEntity> schedules;

  const DoctorScheduleLoaded(this.schedules);
}

class DoctorScheduleError extends DoctorScheduleState {
  final String message;

  const DoctorScheduleError(this.message);
}

class DoctorScheduleUpdating extends DoctorScheduleState {
  const DoctorScheduleUpdating();
}

class DoctorScheduleUpdated extends DoctorScheduleState {
  final DoctorScheduleEntity schedule;

  const DoctorScheduleUpdated(this.schedule);
}
