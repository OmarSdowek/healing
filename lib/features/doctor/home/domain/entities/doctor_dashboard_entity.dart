import 'doctor_appointment_entity.dart';

class DoctorDashboardEntity {
  final int? totalAppointmentsToday;
  final int? confirmedAppointments;
  final int? pendingAppointments;
  final int? totalPatients;
  final List<DoctorAppointmentEntity>? todayAppointments;
  /// All appointments (today + upcoming + past) — used by home screen sections
  final List<DoctorAppointmentEntity>? allAppointments;
  final String? doctorName;
  final String? doctorId;

  DoctorDashboardEntity({
    this.totalAppointmentsToday,
    this.confirmedAppointments,
    this.pendingAppointments,
    this.totalPatients,
    this.todayAppointments,
    this.allAppointments,
    this.doctorName,
    this.doctorId,
  });
}
