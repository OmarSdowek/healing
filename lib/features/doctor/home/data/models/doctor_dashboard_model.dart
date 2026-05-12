import '../../domain/entities/doctor_dashboard_entity.dart';
import 'doctor_appointment_model.dart';

class DoctorDashboardModel extends DoctorDashboardEntity {
  DoctorDashboardModel({
    int? totalAppointmentsToday,
    int? confirmedAppointments,
    int? pendingAppointments,
    int? totalPatients,
    List<DoctorAppointmentModel>? todayAppointments,
    List<DoctorAppointmentModel>? allAppointments,
    String? doctorName,
    String? doctorId,
  }) : super(
          totalAppointmentsToday: totalAppointmentsToday,
          confirmedAppointments: confirmedAppointments,
          pendingAppointments: pendingAppointments,
          totalPatients: totalPatients,
          todayAppointments: todayAppointments,
          allAppointments: allAppointments,
          doctorName: doctorName,
          doctorId: doctorId,
        );
}
