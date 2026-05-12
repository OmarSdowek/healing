import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/doctor_appointment_action_repo.dart';

part 'doctor_appointment_action_state.dart';

class DoctorAppointmentActionCubit
    extends Cubit<DoctorAppointmentActionState> {
  final DoctorAppointmentActionRepo repo;

  DoctorAppointmentActionCubit(this.repo)
      : super(DoctorAppointmentActionInitial());

  Future<void> confirm(int appointmentId) async {
    emit(DoctorAppointmentActionLoading());
    final result = await repo.confirmAppointment(appointmentId);
    result.fold(
      (f) => emit(DoctorAppointmentActionError(f.massage)),
      (_) => emit(DoctorAppointmentActionSuccess('Appointment confirmed')),
    );
  }

  Future<void> complete(int appointmentId, {String? notes}) async {
    emit(DoctorAppointmentActionLoading());
    final result =
        await repo.completeAppointment(appointmentId, notes: notes);
    result.fold(
      (f) => emit(DoctorAppointmentActionError(f.massage)),
      (_) => emit(DoctorAppointmentActionSuccess('Appointment completed')),
    );
  }

  Future<void> cancel(int appointmentId, String reason) async {
    emit(DoctorAppointmentActionLoading());
    final result = await repo.cancelAppointment(appointmentId, reason);
    result.fold(
      (f) => emit(DoctorAppointmentActionError(f.massage)),
      (_) => emit(DoctorAppointmentActionSuccess('Appointment cancelled')),
    );
  }

  Future<void> noShow(int appointmentId) async {
    emit(DoctorAppointmentActionLoading());
    final result = await repo.noShowAppointment(appointmentId);
    result.fold(
      (f) => emit(DoctorAppointmentActionError(f.massage)),
      (_) => emit(DoctorAppointmentActionSuccess('Marked as no-show')),
    );
  }
}
