import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/helper/jwt_helper.dart';
import '../../../../../core/route/routes.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../cubit/doctor_home_cubit.dart';
import '../cubit/doctor_home_cubit_factory.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorHomeCubitFactory.create()..loadTodayAppointments(),
      child: const Scaffold(
        backgroundColor: Color(0xFFF0F4FF),
        body: SafeArea(child: _HomeView()),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
      builder: (context, state) {
        // Loading
        if (state is DoctorHomeLoading ||
            state is DoctorAllAppointmentsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (state is DoctorHomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    size: 56, color: Colors.grey),
                const SizedBox(height: 12),
                Text(state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context
                      .read<DoctorHomeCubit>()
                      .loadTodayAppointments(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Loaded via dashboard (today only)
        if (state is DoctorHomeLoaded) {
          return _HomeContent(
            appointments: state.dashboard.allAppointments ??
                state.dashboard.todayAppointments ??
                [],
          );
        }

        // Loaded via loadTodayAppointments (all schedule days)
        if (state is DoctorAllAppointmentsLoaded) {
          return _HomeContent(appointments: state.appointments);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ─── Main Content ─────────────────────────────────────────────────────────────

class _HomeContent extends StatelessWidget {
  final List<DoctorAppointmentEntity> appointments;
  const _HomeContent({required this.appointments});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final todayList = appointments
        .where((a) => (a.appointmentDate ?? '').startsWith(todayStr))
        .toList()
      ..sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));

    final upcomingList = appointments.where((a) {
      final dt = _parse(a.appointmentDate);
      return DateTime(dt.year, dt.month, dt.day).isAfter(todayDate);
    }).toList()
      ..sort((a, b) =>
          (a.appointmentDate ?? '').compareTo(b.appointmentDate ?? ''));

    final recentList = appointments.where((a) {
      final dt = _parse(a.appointmentDate);
      return DateTime(dt.year, dt.month, dt.day).isBefore(todayDate);
    }).toList()
      ..sort((a, b) =>
          (b.appointmentDate ?? '').compareTo(a.appointmentDate ?? ''));

    // Calculate stats from real data
    int confirmed = 0, pending = 0;
    for (final a in todayList) {
      switch (a.status?.toLowerCase()) {
        case 'confirmed':
          confirmed++;
          break;
        case 'scheduled':
        case 'pending':
          pending++;
          break;
      }
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<DoctorHomeCubit>().loadTodayAppointments(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Top Header ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _TopHeader(
              totalToday: todayList.length,
              confirmed: confirmed,
              pending: pending,
              totalPatients: todayList.length,
            ),
          ),

          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Today ────────────────────────────────────────────────
                _SectionLabel(
                  title: 'Today',
                  count: todayList.length,
                  color: AppColors.primary,
                  onViewAll: () => Navigator.pushNamed(
                      context, Routes.todayAppointments),
                ),
                const SizedBox(height: 10),
                if (todayList.isEmpty)
                  _EmptyTile(label: 'No appointments today')
                else
                  _TodayTimeline(appointments: todayList),

                const SizedBox(height: 24),

                // ── Upcoming ─────────────────────────────────────────────
                _SectionLabel(
                  title: 'Upcoming',
                  count: upcomingList.length,
                  color: const Color(0xFF00B894),
                  onViewAll: () => Navigator.pushNamed(
                      context, Routes.upcomingAppointments),
                ),
                const SizedBox(height: 10),
                if (upcomingList.isEmpty)
                  _EmptyTile(label: 'No upcoming appointments')
                else
                  ...upcomingList
                      .take(3)
                      .map((a) => _UpcomingCard(appointment: a)),

                const SizedBox(height: 24),

                // ── Recent ───────────────────────────────────────────────
                _SectionLabel(
                  title: 'Recent',
                  count: recentList.length,
                  color: Colors.grey,
                  onViewAll: () => Navigator.pushNamed(
                      context, Routes.todayAppointments),
                ),
                const SizedBox(height: 10),
                if (recentList.isEmpty)
                  _EmptyTile(label: 'No recent appointments')
                else
                  ...recentList
                      .take(3)
                      .map((a) => _RecentTile(appointment: a)),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _parse(String? s) {
    if (s == null) return DateTime(2000);
    try {
      return DateTime.parse(s);
    } catch (_) {
      return DateTime(2000);
    }
  }
}

// ─── Top Header ───────────────────────────────────────────────────────────────

class _TopHeader extends StatelessWidget {
  final int totalToday, confirmed, pending, totalPatients;

  const _TopHeader({
    required this.totalToday,
    required this.confirmed,
    required this.pending,
    required this.totalPatients,
  });

  @override
  Widget build(BuildContext context) {
    // Get doctor name from JWT via FutureBuilder
    return FutureBuilder<String?>(
      future: JwtHelper.getFullName(),
      builder: (context, snap) {
        final doctorName = snap.data;
        return Stack(
      children: [
        // Background card
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Top row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                child: Row(
                  children: [
                    // Avatar with ring
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white38, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person_rounded,
                            color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12),
                          ),
                          Text(
                            'Dr. ${doctorName ?? 'Doctor'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification bell
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pushNamed(
                              context, Routes.doctorNotifications),
                          icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 26),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                child: Row(
                  children: [
                    _StatBox(
                        value: totalToday,
                        label: 'Today',
                        icon: Icons.calendar_today_rounded,
                        color: Colors.white),
                    _StatBox(
                        value: confirmed,
                        label: 'Confirmed',
                        icon: Icons.check_circle_rounded,
                        color: const Color(0xFF6EE7B7)),
                    _StatBox(
                        value: pending,
                        label: 'Pending',
                        icon: Icons.schedule_rounded,
                        color: const Color(0xFFFBBF24)),
                    _StatBox(
                        value: totalPatients,
                        label: 'Patients',
                        icon: Icons.people_rounded,
                        color: const Color(0xFF93C5FD)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
      }, // FutureBuilder builder
    ); // FutureBuilder
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning,';
    if (h < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }
}
class _StatBox extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final VoidCallback onViewAll;

  const _SectionLabel({
    required this.title,
    required this.count,
    required this.color,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(width: 6),
        if (count > 0)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w700),
            ),
          ),
        const Spacer(),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            'View All',
            style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ─── Today Timeline ───────────────────────────────────────────────────────────

class _TodayTimeline extends StatelessWidget {
  final List<DoctorAppointmentEntity> appointments;
  const _TodayTimeline({required this.appointments});

  Color _statusColor(String? s) {
    switch (s?.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF00B894);
      case 'scheduled':
        return const Color(0xFFF59E0B);
      case 'completed':
        return const Color(0xFF3B82F6);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: appointments.asMap().entries.map((e) {
          final i = e.key;
          final apt = e.value;
          final time = (apt.startTime ?? '--').length >= 5
              ? apt.startTime!.substring(0, 5)
              : (apt.startTime ?? '--');
          final color = _statusColor(apt.status);
          final isLast = i == appointments.length - 1;

          return InkWell(
            onTap: () {
              if (apt.patientId != null) {
                Navigator.pushNamed(
                  context,
                  Routes.patientDetails,
                  arguments: {
                    'patientId': apt.patientId!,
                    'appointmentId': apt.id ?? 0,
                    'patientName': apt.patientName ?? 'Patient',
                  },
                );
              }
            },
            borderRadius: BorderRadius.vertical(
              top: i == 0 ? const Radius.circular(16) : Radius.zero,
              bottom:
                  isLast ? const Radius.circular(16) : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Time column
                  SizedBox(
                    width: 46,
                    child: Text(
                      time,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151)),
                    ),
                  ),
                  // Color dot + line
                  Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 1.5,
                          height: 28,
                          color: Colors.grey.shade200,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Patient info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apt.patientName ?? '--',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          apt.reasonForVisit ?? apt.type ?? '--',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  // Status pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      apt.status ?? '--',
                      style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Upcoming Card ────────────────────────────────────────────────────────────

class _UpcomingCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  const _UpcomingCard({required this.appointment});

  String _formatDate(String? s) {
    if (s == null) return '--';
    try {
      final dt = DateTime.parse(s);
      const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final time = s.contains('T') ? s.split('T')[1].substring(0, 5) : '';
      return '${days[(dt.weekday - 1).clamp(0, 6)]}, '
          '${months[(dt.month - 1).clamp(0, 11)]} ${dt.day}'
          '${time.isNotEmpty ? ' - $time' : ''}';
    } catch (_) {
      return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = appointment.status?.toLowerCase() ?? '';
    final canCancel = status == 'scheduled' || status == 'confirmed';
    final isNext = status == 'scheduled' || status == 'confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          // ── Date header ──────────────────────────────────────────────
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
                        color: Color(0xFF374151)),
                  ),
                ),
                if (isNext)
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
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // ── Patient info ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Color(0xFF2563EB), size: 36),
                ),
                const SizedBox(width: 14),
                // Name + age + diagnosis
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName ?? 'Patient',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '--', // age placeholder — not in entity
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6B7280)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.reasonForVisit ??
                            appointment.type ??
                            '--',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Action buttons ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                // Add Prescription — goes to Patient Details first (need medical record)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.patientDetails,
                      arguments: {
                        'patientId': appointment.patientId ?? 0,
                        'appointmentId': appointment.id ?? 0,
                        'patientName': appointment.patientName ?? 'Patient',
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
                          fontWeight: FontWeight.w600),
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
                        'patientName': appointment.patientName ?? 'Patient',
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
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Cancel button ────────────────────────────────────────────
          if (canCancel)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _showCancelDialog(context),
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
                        fontWeight: FontWeight.w600),
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

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content: Text(
            "Cancel ${appointment.patientName ?? 'this'}'s appointment?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Recent Tile ──────────────────────────────────────────────────────────────

class _RecentTile extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  const _RecentTile({required this.appointment});

  String _formatDate(String? s) {
    if (s == null) return '--';
    try {
      final dt = DateTime.parse(s);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[(dt.month - 1).clamp(0, 11)]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return s;
    }
  }

  Color _statusColor(String? s) {
    switch (s?.toLowerCase()) {
      case 'completed':
        return const Color(0xFF3B82F6);
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'noshow':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(appointment.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.person_outline,
                color: Colors.grey.shade400, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName ?? 'Patient',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  _formatDate(appointment.appointmentDate),
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Status chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointment.status ?? '--',
              style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          // Arrow
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              Routes.patientDetails,
              arguments: {
                'patientId': appointment.patientId ?? 0,
                'appointmentId': appointment.id ?? 0,
                'patientName': appointment.patientName ?? 'Patient',
              },
            ),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filled Button ────────────────────────────────────────────────────────────

class _FilledBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FilledBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// ─── Empty Tile ───────────────────────────────────────────────────────────────

class _EmptyTile extends StatelessWidget {
  final String label;
  const _EmptyTile({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today_outlined,
              color: Colors.grey.shade300, size: 32),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade400, fontSize: 13)),
        ],
      ),
    );
  }
}
