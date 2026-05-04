class DoctorAppointmentEntity {
  final int? id;
  final String? confirmationNumber;
  final int? patientId;
  final String? patientName;
  final String? patientImage;
  final String? appointmentDate;
  final String? startTime;
  final String? endTime;
  final String? type;
  final String? status;
  final String? reasonForVisit;

  DoctorAppointmentEntity({
    this.id,
    this.confirmationNumber,
    this.patientId,
    this.patientName,
    this.patientImage,
    this.appointmentDate,
    this.startTime,
    this.endTime,
    this.type,
    this.status,
    this.reasonForVisit,
  });
}
