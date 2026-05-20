import '../../domain/entities/doctor_appointment_entity.dart';

class DoctorAppointmentModel extends DoctorAppointmentEntity {
  DoctorAppointmentModel({
    int? id,
    String? confirmationNumber,
    int? patientId,
    String? patientName,
    String? patientImage,
    int? patientAge,
    String? patientMrn,
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
          patientAge: patientAge,
          patientMrn: patientMrn,
          appointmentDate: appointmentDate,
          startTime: startTime,
          endTime: endTime,
          type: type,
          status: status,
          reasonForVisit: reasonForVisit,
        );

  /// Parse a single flat appointment object (old format or new flat format)
  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    // patientName — try every possible key the API might return
    final patientName = (json['patientName'] ??
            json['PatientName'] ??
            json['patient_name'] ??
            json['fullName'] ??
            json['FullName'] ??
            json['name'] ??
            json['Name'] ??
            // nested patient object
            (json['patient'] as Map?)?['fullName'] ??
            (json['patient'] as Map?)?['name'] ??
            (json['Patient'] as Map?)?['fullName'] ??
            (json['Patient'] as Map?)?['name'])
        ?.toString();

    return DoctorAppointmentModel(
      id: ((json['id'] ?? json['Id'] ?? json['appointmentId'] ?? json['AppointmentId']) as num?)?.toInt(),
      confirmationNumber: (json['confirmationNumber'] ?? json['ConfirmationNumber'])?.toString(),
      patientId: ((json['patientId'] ?? json['PatientId']) as num?)?.toInt(),
      patientName: patientName,
      patientImage: (json['patientImage'] ?? json['PatientImage'])?.toString(),
      patientAge: ((json['patientAge'] ?? json['PatientAge'] ?? json['age'] ?? json['Age']) as num?)?.toInt(),
      patientMrn: (json['patientMrn'] ?? json['PatientMrn'] ?? json['medicalRecordNumber'] ?? json['MedicalRecordNumber'])?.toString(),
      appointmentDate: (json['appointmentDate'] ?? json['AppointmentDate'])?.toString(),
      startTime: (json['startTime'] ?? json['StartTime'])?.toString(),
      endTime: (json['endTime'] ?? json['EndTime'])?.toString(),
      type: (json['type'] ?? json['Type'])?.toString(),
      status: (json['status'] ?? json['Status'])?.toString(),
      reasonForVisit: (json['reasonForVisit'] ?? json['ReasonForVisit'])?.toString(),
    );
  }

  /// Parse the NEW grouped response format:
  /// [{ patientId, patientName, age, medicalRecordNumber, appointments: [...] }]
  /// Returns a flat list of appointments with patient info merged in.
  static List<DoctorAppointmentModel> fromGroupedJson(List<dynamic> raw) {
    final result = <DoctorAppointmentModel>[];

    for (final patientObj in raw) {
      final p = patientObj as Map<String, dynamic>;

      final patientId = ((p['patientId'] ?? p['PatientId']) as num?)?.toInt();
      final patientName = (p['patientName'] ?? p['PatientName'])?.toString();
      final patientAge = ((p['age'] ?? p['Age']) as num?)?.toInt();
      final patientMrn = (p['medicalRecordNumber'] ?? p['MedicalRecordNumber'])?.toString();

      final appointments = (p['appointments'] ?? p['Appointments'] ?? []) as List;

      for (final apt in appointments) {
        final a = apt as Map<String, dynamic>;
        result.add(DoctorAppointmentModel(
          id: ((a['appointmentId'] ?? a['AppointmentId'] ?? a['id'] ?? a['Id']) as num?)?.toInt(),
          confirmationNumber: (a['confirmationNumber'] ?? a['ConfirmationNumber'])?.toString(),
          patientId: patientId,
          patientName: patientName,
          patientAge: patientAge,
          patientMrn: patientMrn,
          appointmentDate: (a['appointmentDate'] ?? a['AppointmentDate'])?.toString(),
          startTime: (a['startTime'] ?? a['StartTime'])?.toString(),
          endTime: (a['endTime'] ?? a['EndTime'])?.toString(),
          type: (a['type'] ?? a['Type'])?.toString(),
          status: (a['status'] ?? a['Status'])?.toString(),
          reasonForVisit: (a['reasonForVisit'] ?? a['ReasonForVisit'])?.toString(),
        ));
      }
    }

    return result;
  }
}
