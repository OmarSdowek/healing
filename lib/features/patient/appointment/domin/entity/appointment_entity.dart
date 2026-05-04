class AppointmentEntity {
  final int id;
  final String confirmationNumber;
  final int patientId;
  final String patientName;
  final int doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String type;
  final String? reasonForVisit;

  AppointmentEntity({
    required this.id,
    required this.confirmationNumber,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.type,
    this.reasonForVisit,
  });
}
