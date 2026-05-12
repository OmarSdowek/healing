import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../home/domain/entities/doctor_appointment_entity.dart';
import '../../../home/presentation/cubit/doctor_home_cubit.dart';
import '../../../home/presentation/cubit/doctor_home_cubit_factory.dart';
import '../cubit/doctor_appointment_action_cubit.dart';
import '../../../../doctor/appointments/data/repositories/doctor_appointment_action_repo_impl.dart';
import '../../../../../core/network/api_service.dart';

class TodayAppointmentsScreen extends StatelessWidget {
  const TodayAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = DoctorHomeCubitFactory.create();
            cubit.loadTodayAppointments(); // Single request
            return cubit;
          },
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Reload after action
            context.read<DoctorHomeCubit>().loadTodayAppointments();
          } else if (state is DoctorAppointmentActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          body: SafeArea(
            child: Column(
              children: [
                const CustomHeader(title: "Appointments"),
                Expanded(
                  child: BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
                    builder: (context, state) {
                      if (state is DoctorAllAppointmentsLoading ||
                          state is DoctorHomeLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (state is DoctorHomeError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 12),
                              Text(state.message,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<DoctorHomeCubit>()
                                    .loadTodayAppointments(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is DoctorAllAppointmentsLoaded) {
                        return _AppointmentsList(
                          appointments: state.appointments,
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

// ─── Appointments List with grouping ─────────────────────────────────────────

class _AppointmentsList extends StatelessWidget {
  final List<DoctorAppointmentEntity> appointments;

  const _AppointmentsList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No appointments found",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    final now = DateTime.now();
    // Compare dates only (strip time)
    final todayDate = DateTime(now.year, now.month, now.day);

    List<DoctorAppointmentEntity> todayList = [];
    List<DoctorAppointmentEntity> upcomingList = [];
    List<DoctorAppointmentEntity> pastList = [];

    for (final apt in appointments) {
      final dt = _parseDate(apt.appointmentDate);
      final aptDate = DateTime(dt.year, dt.month, dt.day);

      if (aptDate == todayDate) {
        todayList.add(apt);
      } else if (aptDate.isAfter(todayDate)) {
        upcomingList.add(apt);
      } else {
        pastList.add(apt);
      }
    }

    // Sort each group
    todayList.sort((a, b) =>
        (a.startTime ?? '').compareTo(b.startTime ?? ''));
    upcomingList.sort((a, b) =>
        (a.appointmentDate ?? '').compareTo(b.appointmentDate ?? ''));
    pastList.sort((a, b) =>
        (b.appointmentDate ?? '').compareTo(a.appointmentDate ?? ''));

    return RefreshIndicator(
      onRefresh: () =>
          context.read<DoctorHomeCubit>().loadTodayAppointments(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          if (todayList.isNotEmpty) ...[
            _SectionLabel(
              label: "Today",
              count: todayList.length,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            ...todayList.map((apt) => _AppointmentCard(appointment: apt)),
            const SizedBox(height: 16),
          ],
          if (upcomingList.isNotEmpty) ...[
            _SectionLabel(
              label: "Upcoming",
              count: upcomingList.length,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            ...upcomingList
                .map((apt) => _AppointmentCard(appointment: apt)),
            const SizedBox(height: 16),
          ],
          if (pastList.isNotEmpty) ...[
            _SectionLabel(
              label: "Past",
              count: pastList.length,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            ...pastList.map((apt) => _AppointmentCard(appointment: apt)),
          ],
        ],
      ),
    );
  }

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime(2000);
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return DateTime(2000);
    }
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SectionLabel({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.semiBold16Black.copyWith(
            fontSize: 15,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Appointment Card ─────────────────────────────────────────────────────────

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;

  const _AppointmentCard({required this.appointment});

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'scheduled':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'noshow':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '--';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String _formatTime(String? time) {
    if (time == null) return '--';
    return time.length >= 5 ? time.substring(0, 5) : time;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(appointment.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showActionSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.person_outline,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.patientName ?? 'Patient',
                          style: AppTextStyles.semiBold16Black
                              .copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appointment.reasonForVisit ??
                              appointment.type ??
                              'No reason provided',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (appointment.status ?? 'Unknown').toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(appointment.appointmentDate),
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    final cubit = context.read<DoctorAppointmentActionCubit>();
    final status = appointment.status?.toLowerCase() ?? '';
    final isScheduled = status == 'scheduled';
    final isConfirmed = status == 'confirmed';
    final canAct = isScheduled || isConfirmed;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              appointment.patientName ?? 'Patient',
              style:
                  AppTextStyles.semiBold16Black.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Divider(),

            // View patient details
            ListTile(
              leading: const Icon(Icons.person_search,
                  color: AppColors.primary),
              title: const Text("View Patient Details"),
              onTap: () {
                Navigator.pop(context);
                if (appointment.patientId != null) {
                  Navigator.pushNamed(
                    context,
                    Routes.patientDetails,
                    arguments: {
                      'patientId': appointment.patientId!,
                      'appointmentId': appointment.id ?? 0,
                      'patientName':
                          appointment.patientName ?? 'Patient',
                    },
                  );
                }
              },
            ),

            if (isScheduled)
              ListTile(
                leading: const Icon(Icons.check_circle_outline,
                    color: Colors.green),
                title: const Text("Confirm Appointment"),
                onTap: () {
                  Navigator.pop(context);
                  cubit.confirm(appointment.id ?? 0);
                },
              ),

            if (isConfirmed)
              ListTile(
                leading:
                    const Icon(Icons.done_all, color: Colors.blue),
                title: const Text("Complete Appointment"),
                onTap: () {
                  Navigator.pop(context);
                  cubit.complete(appointment.id ?? 0);
                },
              ),

            if (isConfirmed)
              ListTile(
                leading: const Icon(Icons.person_off_outlined,
                    color: Colors.grey),
                title: const Text("Mark as No-Show"),
                onTap: () {
                  Navigator.pop(context);
                  cubit.noShow(appointment.id ?? 0);
                },
              ),

            if (canAct)
              ListTile(
                leading: const Icon(Icons.cancel_outlined,
                    color: Colors.red),
                title: const Text("Cancel Appointment"),
                onTap: () {
                  Navigator.pop(context);
                  _showCancelDialog(context, cubit);
                },
              ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, DoctorAppointmentActionCubit cubit) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            hintText: "Enter cancellation reason",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.cancel(
                appointment.id ?? 0,
                reasonCtrl.text.isNotEmpty
                    ? reasonCtrl.text
                    : "Doctor cancelled",
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
