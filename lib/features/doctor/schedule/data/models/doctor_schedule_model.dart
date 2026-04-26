import '../../domain/entities/doctor_schedule_entity.dart';

class DoctorScheduleModel extends DoctorScheduleEntity {
  DoctorScheduleModel({
    int? id,
    int? doctorId,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    bool? isActive,
  }) : super(
         id: id,
         doctorId: doctorId,
         dayOfWeek: dayOfWeek,
         startTime: startTime,
         endTime: endTime,
         isActive: isActive,
       );

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      id: json['id'],
      doctorId: json['doctorId'],
      dayOfWeek: json['dayOfWeek'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
    };
  }
}
