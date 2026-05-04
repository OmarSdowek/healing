import 'doctor_appointment_entity.dart';

class DoctorDashboardEntity {
  final int? totalAppointmentsToday;
  final int? confirmedAppointments;
  final int? pendingAppointments;
  final int? totalPatients;
  final List<DoctorAppointmentEntity>? todayAppointments;

  DoctorDashboardEntity({
    this.totalAppointmentsToday,
    this.confirmedAppointments,
    this.pendingAppointments,
    this.totalPatients,
    this.todayAppointments,
  });
}
