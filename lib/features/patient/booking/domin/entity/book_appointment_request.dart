class BookAppointmentRequest {
  final int patientId;
  final int doctorId;
  final String appointmentDate; // YYYY-MM-DD
  final String startTime;       // HH:mm:ss
  final String type;            // "InPerson", "Video", "Phone"
  final String reasonForVisit;

  BookAppointmentRequest({
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.startTime,
    required this.type,
    required this.reasonForVisit,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'doctorId': doctorId,
        'appointmentDate': appointmentDate,
        'startTime': startTime,
        'type': type,
        'reasonForVisit': reasonForVisit,
      };
}
