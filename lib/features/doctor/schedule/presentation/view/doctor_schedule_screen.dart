import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../appointments/data/repositories/doctor_appointment_action_repo_impl.dart';
import '../../../appointments/presentation/cubit/doctor_appointment_action_cubit.dart';
import '../../../home/domain/entities/doctor_appointment_entity.dart';
import '../../../home/presentation/cubit/doctor_home_cubit.dart';
import '../../../home/presentation/cubit/doctor_home_cubit_factory.dart';
import '../../../../../core/network/api_service.dart';

class DoctorScheduleScreen extends StatelessWidget {
  const DoctorScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              DoctorHomeCubitFactory.create()..loadTodayAppointments(),
        ),
        BlocProvider(
          create: (_) => DoctorAppointmentActionCubit(
            DoctorAppointmentActionRepoImpl(ApiService()),
          ),
        ),
      ],
      child: BlocListener<DoctorAppointmentActionCubit,
          DoctorAppointmentActionState>(
        listener: (context, state) {
          if (state is DoctorAppointmentActionSuccess) {
            AppSnackBar.showSuccess(context, state.message);
            context.read<DoctorHomeCubit>().loadTodayAppointments();
          } else if (state is DoctorAppointmentActionError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F4FF),
          body: SafeArea(
            child: Column(
              children: [
                const CustomHeader(title: "Upcoming Appointment"),
                Expanded(
                  child: BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
                    builder: (context, state) {
                      if (state is DoctorAllAppointmentsLoading ||
                          state is DoctorHomeLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (state is DoctorHomeError) {
                        return _EmptyState(
                          icon: Icons.wifi_off_rounded,
                          title: "Couldn't load appointments",
                          subtitle: state.message,
                          onRetry: () => context
                              .read<DoctorHomeCubit>()
                              .loadTodayAppointments(),
                        );
                      }

                      if (state is DoctorAllAppointmentsLoaded) {
                        final now = DateTime.now();
                        final todayDate =
                            DateTime(now.year, now.month, now.day);

                        // Show upcoming only (today and future)
                        final upcoming = state.appointments.where((a) {
                          try {
                            final dt =
                                DateTime.parse(a.appointmentDate ?? '');
                            final aptDate =
                                DateTime(dt.year, dt.month, dt.day);
                            return !aptDate.isBefore(todayDate);
                          } catch (_) {
                            return false;
                          }
                        }).toList()
                          ..sort((a, b) =>
                              (a.appointmentDate ?? '').compareTo(
                                  b.appointmentDate ?? ''));

                        if (upcoming.isEmpty) {
                          return _EmptyState(
                            icon: Icons.calendar_today_outlined,
                            title: "No upcoming appointments",
                            subtitle:
                                "Your upcoming appointments will appear here",
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () => context
                              .read<DoctorHomeCubit>()
                              .loadTodayAppointments(),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            itemCount: upcoming.length,
                            itemBuilder: (context, i) =>
                                _AppointmentCard(appointment: upcoming[i]),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Appointment Card ─────────────────────────────────────────────────────────

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  const _AppointmentCard({required this.appointment});

  String _formatDate(String? s) {
    if (s == null) return '--';
    try {
      final dt = DateTime.parse(s);
      const days = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday', 'Sunday'
      ];
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final time =
          s.contains('T') ? s.split('T')[1].substring(0, 5) : '';
      final timeFormatted = _to12h(time);
      return '${days[(dt.weekday - 1).clamp(0, 6)]}, '
          '${months[(dt.month - 1).clamp(0, 11)]} ${dt.day}'
          '${timeFormatted.isNotEmpty ? ' - $timeFormatted' : ''}';
    } catch (_) {
      return s;
    }
  }

  String _to12h(String time24) {
    if (time24.length < 5) return time24;
    try {
      final parts = time24.split(':');
      int hour = int.parse(parts[0]);
      final min = parts[1];
      final period = hour >= 12 ? 'Pm' : 'Am';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:$min $period';
    } catch (_) {
      return time24;
    }
  }

  bool get _isNext {
    final s = appointment.status?.toLowerCase() ?? '';
    return s == 'scheduled' || s == 'confirmed';
  }

  @override
  Widget build(BuildContext context) {
    final actionCubit = context.read<DoctorAppointmentActionCubit>();
    final canCancel = _isNext;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Date header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    size: 15, color: Color(0xFF2563EB)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _formatDate(appointment.appointmentDate),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                if (_isNext)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Next Appointment",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // ── Patient info ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF2563EB),
                    size: 34,
                  ),
                ),
                const SizedBox(width: 14),
                // Name + diagnosis
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName ?? 'Patient',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.reasonForVisit ??
                            appointment.type ??
                            '--',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Buttons ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                // Add Prescription — outlined
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.addPrescription,
                      arguments: {
                        'patientId': appointment.patientId,
                        'patientName': appointment.patientName,
                        'patientAge': appointment.patientAge,
                        'patientMrn': appointment.patientMrn,
                        'appointmentId': appointment.id,
                      },
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF2563EB), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      "Add Prescription",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Open Record — filled
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
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
                      backgroundColor: const Color(0xFF1E3A8A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      "Open Record",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Cancel button ──────────────────────────────────────────
          if (canCancel)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () =>
                      _showCancelDialog(context, actionCubit),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF9FAFB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    "Cancel Appointment",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, DoctorAppointmentActionCubit cubit) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
              hintText: "Enter cancellation reason"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.cancel(
                appointment.id ?? 0,
                ctrl.text.isNotEmpty ? ctrl.text : "Doctor cancelled",
              );
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Retry"),
            ),
          ],
        ],
      ),
    );
  }
}
