import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import '../../domain/entities/doctor_appointment_entity.dart';

/// Displays today's appointments as a timeline list.
/// Receives real data — no hardcoded values.
class TodayAppointmentSection extends StatelessWidget {
  final List<DoctorAppointmentEntity> appointments;

  const TodayAppointmentSection({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: 'Today Appointment',
          onViewAll: () =>
              Navigator.pushNamed(context, Routes.todayAppointments),
        ),
        context.verticalSpace(10),
        if (appointments.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
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
            child: Center(
              child: Text(
                'No appointments today',
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          Container(
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
              children: [
                // ── Header row ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Time',
                          style: AppTextStyles.semiBold16Black.copyWith(
                            fontSize: context.sp(13),
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Name',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.semiBold16Black.copyWith(
                            fontSize: context.sp(13),
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Text(
                        'Status',
                        style: AppTextStyles.semiBold16Black.copyWith(
                          fontSize: context.sp(13),
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // ── Appointment rows ─────────────────────────────────────
                ...appointments.map(
                  (apt) => _AppointmentRow(appointment: apt),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AppointmentRow extends StatelessWidget {
  final DoctorAppointmentEntity appointment;

  const _AppointmentRow({required this.appointment});

  String _formatTime(String? time) {
    if (time == null || time.length < 5) return '--';
    try {
      final parts = time.substring(0, 5).split(':');
      int hour = int.parse(parts[0]);
      final min = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:$min\n$period';
    } catch (_) {
      return time.substring(0, 5);
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

  Color _statusBg(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFD1FAE5);
      case 'completed':
        return const Color(0xFFDBEAFE);
      case 'cancelled':
        return const Color(0xFFFFE4E6);
      default:
        return const Color(0xFFFFF3CD);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel =
        (appointment.status ?? 'WAITING').toUpperCase();
    final color = _statusColor(appointment.status);
    final bg = _statusBg(appointment.status);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 50,
            child: Text(
              _formatTime(appointment.startTime),
              style: AppTextStyles.semiBold16Black.copyWith(
                fontSize: context.sp(12),
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
          ),
          // Patient info
          Expanded(
            child: Row(
              children: [
                Icon(Icons.person_outline,
                    color: AppColors.grey, size: context.sp(20)),
                context.horizontalSpace(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName ?? '--',
                        style: AppTextStyles.semiBold16Black.copyWith(
                          fontSize: context.sp(13),
                          color: AppColors.primaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        appointment.reasonForVisit ??
                            appointment.type ??
                            '--',
                        style: AppTextStyles.semiBold16Black.copyWith(
                          fontSize: context.sp(11),
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: color, size: 8),
                const SizedBox(width: 4),
                Text(
                  statusLabel,
                  style: AppTextStyles.semiBold16Black.copyWith(
                    fontSize: context.sp(10),
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.semiBold24dark.copyWith(
            color: AppColors.primaryText,
            fontSize: context.sp(18),
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            'View All',
            style: AppTextStyles.semiBold16Black.copyWith(
              color: AppColors.primary,
              fontSize: context.sp(14),
            ),
          ),
        ),
      ],
    );
  }
}
