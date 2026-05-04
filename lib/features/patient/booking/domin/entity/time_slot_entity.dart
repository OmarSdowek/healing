class TimeSlotEntity {
  final int doctorId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  TimeSlotEntity({
    required this.doctorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });
}
