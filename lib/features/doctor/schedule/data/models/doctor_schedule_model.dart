import '../../domain/entities/doctor_schedule_entity.dart';

class DoctorScheduleModel extends DoctorScheduleEntity {
  DoctorScheduleModel({
    int? id,
    int? doctorId,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    bool? isActive,
    int? slotDurationMinutes,
    int? maxAppointmentsPerSlot,
  }) : super(
         id: id,
         doctorId: doctorId,
         dayOfWeek: dayOfWeek,
         startTime: startTime,
         endTime: endTime,
         isActive: isActive,
         slotDurationMinutes: slotDurationMinutes,
         maxAppointmentsPerSlot: maxAppointmentsPerSlot,
       );

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      // Handle both PascalCase (API) and camelCase
      id: ((json['Id'] ?? json['id']) as num?)?.toInt(),
      doctorId: ((json['DoctorId'] ?? json['doctorId']) as num?)?.toInt(),
      dayOfWeek: (json['DayOfWeek'] ?? json['dayOfWeek'])?.toString(),
      startTime: (json['StartTime'] ?? json['startTime'])?.toString(),
      endTime: (json['EndTime'] ?? json['endTime'])?.toString(),
      isActive: (json['IsAvailable'] ?? json['isAvailable'] ??
          json['IsActive'] ?? json['isActive']) as bool?,
      slotDurationMinutes:
          ((json['SlotDurationMinutes'] ?? json['slotDurationMinutes'])
                  as num?)
              ?.toInt(),
      maxAppointmentsPerSlot:
          ((json['MaxAppointmentsPerSlot'] ?? json['maxAppointmentsPerSlot'])
                  as num?)
              ?.toInt(),
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
      if (slotDurationMinutes != null)
        'slotDurationMinutes': slotDurationMinutes,
      if (maxAppointmentsPerSlot != null)
        'maxAppointmentsPerSlot': maxAppointmentsPerSlot,
    };
  }
}
