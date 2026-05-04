import '../../domain/entities/doctor_appointment_entity.dart';

class DoctorAppointmentModel extends DoctorAppointmentEntity {
  DoctorAppointmentModel({
    int? id,
    String? confirmationNumber,
    int? patientId,
    String? patientName,
    String? patientImage,
    String? appointmentDate,
    String? startTime,
    String? endTime,
    String? type,
    String? status,
    String? reasonForVisit,
  }) : super(
         id: id,
         confirmationNumber: confirmationNumber,
         patientId: patientId,
         patientName: patientName,
         patientImage: patientImage,
         appointmentDate: appointmentDate,
         startTime: startTime,
         endTime: endTime,
         type: type,
         status: status,
         reasonForVisit: reasonForVisit,
       );

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentModel(
      id: json['id'],
      confirmationNumber: json['confirmationNumber'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      patientImage: json['patientImage'],
      appointmentDate: json['appointmentDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      type: json['type'],
      status: json['status'],
      reasonForVisit: json['reasonForVisit'],
    );
  }
}
