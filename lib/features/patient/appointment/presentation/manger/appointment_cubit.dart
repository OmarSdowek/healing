import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domin/entity/appointment_entity.dart';
import '../../domin/use_cases/cancel_appointment_use_case.dart';
import '../../domin/use_cases/get_patient_appointments_use_case.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final GetPatientAppointmentsUseCase getPatientAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  AppointmentCubit(
    this.getPatientAppointmentsUseCase,
    this.cancelAppointmentUseCase,
  ) : super(AppointmentInitial());

  List<AppointmentEntity> _allAppointments = [];

  /// Load patient appointments
  Future<void> loadAppointments(int patientId) async {
    print("🔥 AppointmentCubit: loadAppointments($patientId) called");
    emit(AppointmentLoading());

    final result = await getPatientAppointmentsUseCase(patientId);

    if (isClosed) return;

    result.fold(
      (failure) {
        print("❌ AppointmentCubit: Error - ${failure.massage}");
        if (!isClosed) emit(AppointmentError(failure.massage));
      },
      (appointments) {
        print("✅ AppointmentCubit: Got ${appointments.length} appointments");
        _allAppointments = appointments;
        if (!isClosed) emit(AppointmentLoaded(appointments));
      },
    );
  }

  /// Cancel a single appointment by ID
  Future<void> cancelAppointment(int appointmentId, String reason) async {
    // Keep current state to restore on failure
    final previousAppointments = List<AppointmentEntity>.from(_allAppointments);

    emit(AppointmentCancelling());

    final result = await cancelAppointmentUseCase(appointmentId, reason);

    if (isClosed) return;

    result.fold(
      (failure) {
        // Restore previous list on failure
        emit(AppointmentLoaded(previousAppointments));
        emit(AppointmentError(failure.massage));
      },
      (_) {
        // Update only the cancelled appointment's status in the list
        // Do NOT remove it — keep all appointments visible
        _allAppointments = _allAppointments.map((apt) {
          if (apt.id == appointmentId) {
            return _copyWithStatus(apt, 'Cancelled');
          }
          return apt;
        }).toList();

        emit(AppointmentCancelSuccess());
        emit(AppointmentLoaded(_allAppointments));
      },
    );
  }

  /// Creates a copy of AppointmentEntity with updated status
  AppointmentEntity _copyWithStatus(AppointmentEntity apt, String status) {
    return AppointmentEntity(
      id: apt.id,
      confirmationNumber: apt.confirmationNumber,
      patientId: apt.patientId,
      patientName: apt.patientName,
      doctorId: apt.doctorId,
      doctorName: apt.doctorName,
      doctorSpecialization: apt.doctorSpecialization,
      appointmentDate: apt.appointmentDate,
      startTime: apt.startTime,
      endTime: apt.endTime,
      status: status,
      type: apt.type,
      reasonForVisit: apt.reasonForVisit,
    );
  }
}
