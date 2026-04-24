class AppointmentModel {
  final int id;
  final String confirmationNumber;
  final String status;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final String type;
  final String reasonForVisit;
  final String? notes;
  final PatientBriefModel patient;

  AppointmentModel({
    required this.id,
    required this.confirmationNumber,
    required this.status,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.reasonForVisit,
    this.notes,
    required this.patient,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json["id"] ?? 0,
        confirmationNumber: json["confirmationNumber"] ?? "",
        status: json["status"] ?? "",
        appointmentDate: json["appointmentDate"] ?? "",
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        type: json["type"] ?? "",
        reasonForVisit: json["reasonForVisit"] ?? "",
        notes: json["notes"],
        patient: PatientBriefModel.fromJson(json["patient"] ?? {}),
      );
}

class PatientBriefModel {
  final int id;
  final String fullName;
  final String medicalRecordNumber;

  PatientBriefModel({
    required this.id,
    required this.fullName,
    required this.medicalRecordNumber,
  });

  factory PatientBriefModel.fromJson(Map<String, dynamic> json) =>
      PatientBriefModel(
        id: json["id"] ?? 0,
        fullName: json["fullName"] ?? "",
        medicalRecordNumber: json["medicalRecordNumber"] ?? "",
      );
}
