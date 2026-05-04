import '../../domin/entity/time_slot_entity.dart';

class TimeSlotModel extends TimeSlotEntity {
  TimeSlotModel({
    required super.doctorId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.isAvailable,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      doctorId: (json['doctorId'] as num).toInt(),
      date: json['date']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }
}
