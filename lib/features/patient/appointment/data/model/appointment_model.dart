
import '../../domin/entity/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.confirmationNumber,
    required super.patientId,
    required super.patientName,
    required super.doctorId,
    required super.doctorName,
    required super.doctorSpecialization,
    required super.appointmentDate,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.type,
    super.reasonForVisit,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // API sometimes returns PascalCase (Id, DoctorName) — handle both
    return AppointmentModel(
      id: ((json['id'] ?? json['Id']) as num?)?.toInt() ?? 0,
      confirmationNumber:
          (json['confirmationNumber'] ?? json['ConfirmationNumber'])
                  ?.toString() ??
              '',
      patientId:
          ((json['patientId'] ?? json['PatientId']) as num?)?.toInt() ?? 0,
      patientName:
          (json['patientName'] ?? json['PatientName'])?.toString() ?? '',
      doctorId:
          ((json['doctorId'] ?? json['DoctorId']) as num?)?.toInt() ?? 0,
      doctorName:
          (json['doctorName'] ?? json['DoctorName'])?.toString() ?? '',
      doctorSpecialization:
          (json['doctorSpecialization'] ?? json['DoctorSpecialization'])
                  ?.toString() ??
              '',
      appointmentDate:
          (json['appointmentDate'] ?? json['AppointmentDate'])?.toString() ??
              '',
      startTime:
          (json['startTime'] ?? json['StartTime'])?.toString() ?? '',
      endTime: (json['endTime'] ?? json['EndTime'])?.toString() ?? '',
      status: (json['status'] ?? json['Status'])?.toString() ?? '',
      type: (json['type'] ?? json['Type'])?.toString() ?? '',
      reasonForVisit:
          (json['reasonForVisit'] ?? json['ReasonForVisit'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'confirmationNumber': confirmationNumber,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialization': doctorSpecialization,
      'appointmentDate': appointmentDate,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'type': type,
      'reasonForVisit': reasonForVisit,
    };
  }

  // Helper to check if appointment is upcoming
  bool get isUpcoming {
    return status == 'Scheduled' || status == 'Confirmed';
  }

  // Helper to format date and time
  String get formattedDateTime {
    return '$appointmentDate at $startTime';
  }
}
