import '../../domain/entities/doctor_dashboard_entity.dart';
import 'doctor_appointment_model.dart';

class DoctorDashboardModel extends DoctorDashboardEntity {
  DoctorDashboardModel({
    int? totalAppointmentsToday,
    int? confirmedAppointments,
    int? pendingAppointments,
    int? totalPatients,
    List<DoctorAppointmentModel>? todayAppointments,
  }) : super(
         totalAppointmentsToday: totalAppointmentsToday,
         confirmedAppointments: confirmedAppointments,
         pendingAppointments: pendingAppointments,
         totalPatients: totalPatients,
         todayAppointments: todayAppointments,
       );

  factory DoctorDashboardModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardModel(
      totalAppointmentsToday: json['totalAppointmentsToday'],
      confirmedAppointments: json['confirmedAppointments'],
      pendingAppointments: json['pendingAppointments'],
      totalPatients: json['totalPatients'],
      todayAppointments: (json['todayAppointments'] as List?)
          ?.map((e) => DoctorAppointmentModel.fromJson(e))
          .toList(),
    );
  }
}
