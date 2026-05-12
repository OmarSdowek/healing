class DoctorScheduleEntity {
  final int? id;
  final int? doctorId;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final bool? isActive;
  final int? slotDurationMinutes;
  final int? maxAppointmentsPerSlot;

  DoctorScheduleEntity({
    this.id,
    this.doctorId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.isActive,
    this.slotDurationMinutes,
    this.maxAppointmentsPerSlot,
  });
}
