import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import '../../domain/entities/doctor_appointment_entity.dart';

/// Appointment card for the doctor home screen.
/// Displays real data from [DoctorAppointmentEntity].
class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  final VoidCallback? onAddPrescription;
  final VoidCallback? onOpenRecord;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onAddPrescription,
    this.onOpenRecord,
  });

  String _formatDate(String? s) {
    if (s == null) return '--';
    try {
      final dt = DateTime.parse(s);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return s;
    }
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF00B894);
      case 'completed':
        return const Color(0xFF3B82F6);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFFFC107);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(appointment.status);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Date + Status ──────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: context.sp(14), color: AppColors.grey),
              context.horizontalSpace(6),
              Text(
                _formatDate(appointment.appointmentDate),
                style: AppTextStyles.semiBold16Black.copyWith(
                  fontSize: context.sp(13),
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              Text(
                appointment.status ?? '--',
                style: AppTextStyles.semiBold16Black.copyWith(
                  fontSize: context.sp(13),
                  color: statusColor,
                ),
              ),
            ],
          ),
          context.verticalSpace(12),

          // ── Patient info ───────────────────────────────────────────
          Row(
            children: [
              Container(
                width: context.w(60),
                height: context.h(60),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person_rounded,
                    color: AppColors.primary, size: context.sp(32)),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName ?? '--',
                      style: AppTextStyles.semiBold16Black.copyWith(
                        fontSize: context.sp(15),
                        color: AppColors.primaryText,
                      ),
                    ),
                    context.verticalSpace(4),
                    Text(
                      appointment.reasonForVisit ??
                          appointment.type ??
                          '--',
                      style: AppTextStyles.semiBold16Black.copyWith(
                        fontSize: context.sp(13),
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(14),

          // ── Action buttons ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onAddPrescription ??
                      () => Navigator.pushNamed(
                            context,
                            Routes.patientDetails,
                            arguments: {
                              'patientId': appointment.patientId ?? 0,
                              'appointmentId': appointment.id ?? 0,
                              'patientName': appointment.patientName ?? 'Patient',
                            },
                          ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Add Prescription',
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.primary,
                      fontSize: context.sp(13),
                    ),
                  ),
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenRecord ??
                      () => Navigator.pushNamed(
                            context,
                            Routes.patientDetails,
                            arguments: {
                              'patientId': appointment.patientId ?? 0,
                              'appointmentId': appointment.id ?? 0,
                              'patientName':
                                  appointment.patientName ?? 'Patient',
                            },
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Open Record',
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.white,
                      fontSize: context.sp(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
