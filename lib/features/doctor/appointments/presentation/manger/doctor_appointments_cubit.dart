import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/complete_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/confirm_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/get_doctor_appointments_use_case.dart';

part 'doctor_appointments_state.dart';

class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  final GetDoctorAppointmentsUseCase _getAppointments;
  final ConfirmAppointmentUseCase _confirm;
  final CompleteAppointmentUseCase _complete;

  DoctorAppointmentsCubit(this._getAppointments, this._confirm, this._complete)
    : super(DoctorAppointmentsInitial());

  Future<void> loadAppointments({required int doctorId, String? date}) async {
    emit(DoctorAppointmentsLoading());
    final result = await _getAppointments(
      GetDoctorAppointmentsParams(doctorId: doctorId, date: date),
    );
    result.fold(
      (f) => emit(DoctorAppointmentsError(f.massage)),
      (list) => emit(DoctorAppointmentsLoaded(list)),
    );
  }

  Future<void> confirmAppointment(int id) async {
    final result = await _confirm(id);
    result.fold(
      (f) => emit(DoctorAppointmentsError(f.massage)),
      (updated) => emit(DoctorAppointmentActionSuccess(updated)),
    );
  }

  Future<void> completeAppointment({required int id, String? notes}) async {
    final result = await _complete(
      CompleteAppointmentParams(id: id, notes: notes),
    );
    result.fold(
      (f) => emit(DoctorAppointmentsError(f.massage)),
      (updated) => emit(DoctorAppointmentActionSuccess(updated)),
    );
  }
}
