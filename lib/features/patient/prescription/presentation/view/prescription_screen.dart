import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../../medical_report/presentation/manger/medical_report_cubit.dart';
import '../widgets/prescription_header.dart';
import '../widgets/mediction_item.dart';
import '../widgets/doctor_notes_section.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientAuthCubit>(
      create: (_) => sl<PatientAuthCubit>()..meData(),
      child: BlocBuilder<PatientAuthCubit, PatientAuthState>(
        builder: (ctx, authState) {
          int patientId = 0;
          if (authState is PatientDataSuccess) {
            patientId =
                int.tryParse(authState.meData.patientId ?? '0') ?? 0;
          }

          if (patientId == 0) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return BlocProvider<MedicalReportCubit>(
            key: ValueKey('prescriptions_$patientId'),
            create: (_) =>
                sl<MedicalReportCubit>()..loadPrescriptions(patientId),
            child: Scaffold(
              backgroundColor: const Color(0xFFF4F6FB),
              body: SafeArea(
                child: Column(
                  children: [
                    const CustomHeader(title: 'My Prescriptions'),
                    Expanded(
                      child: BlocBuilder<MedicalReportCubit,
                          MedicalReportState>(
                        builder: (context, state) {
                          if (state is MedicalReportLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (state is MedicalReportError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error_outline,
                                        size: 48, color: Colors.red),
                                    const SizedBox(height: 12),
                                    Text(state.message,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red.shade700)),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (state is PrescriptionsLoaded) {
                            if (state.prescriptions.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.medication_outlined,
                                        size: 64,
                                        color: Colors.grey.shade400),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No prescriptions yet',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: state.prescriptions.length,
                              itemBuilder: (context, i) {
                                final rx = state.prescriptions[i];
                                // Fix doctor name: if "Doctor #17" use doctorId to show better label
                                return _PrescriptionListCard(
                                  prescription: rx,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PrescriptionDetailScreen(
                                              prescription: rx),
                                    ),
                                  ),
                                );
                              },
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
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Prescription List Card — tappable summary card
// ─────────────────────────────────────────────────────────────────────────────

class _PrescriptionListCard extends StatelessWidget {
  final dynamic prescription;
  final VoidCallback onTap;

  const _PrescriptionListCard({
    required this.prescription,
    required this.onTap,
  });

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'expired':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rx = prescription;
    final statusColor = _statusColor(rx.status);
    final med = rx.medications.isNotEmpty ? rx.medications.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor row ─────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.person,
                      color: AppColors.primary, size: 24),
                ),
                context.horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rx.doctor.name.isNotEmpty &&
                                !rx.doctor.name.startsWith('Doctor #')
                            ? 'Dr. ${rx.doctor.name}'
                            : 'Prescribing Doctor',
                        style: AppTextStyles.semiBold16Black,
                      ),
                      if (rx.doctor.specialization.isNotEmpty)
                        Text(
                          rx.doctor.specialization,
                          style: AppTextStyles.semiBold16Black.copyWith(
                              color: Colors.grey, fontSize: 13),
                        )
                      else
                        Text(
                          'Doctor ID: ${rx.doctor.id}',
                          style: AppTextStyles.semiBold16Black.copyWith(
                              color: Colors.grey, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rx.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            // ── First medication preview ───────────────────────────────
            if (med != null)
              Row(
                children: [
                  const Icon(Icons.medication_outlined,
                      size: 16, color: AppColors.primary),
                  context.horizontalSpace(8),
                  Expanded(
                    child: Text(
                      med.name,
                      style: AppTextStyles.semiBold16Black
                          .copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${med.durationDays} days',
                    style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.primary, fontSize: 13),
                  ),
                ],
              ),

            if (rx.medications.length > 1) ...[
              context.verticalSpace(4),
              Text(
                '+${rx.medications.length - 1} more medication(s)',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade500),
              ),
            ],

            // ── Date ──────────────────────────────────────────────────
            if (rx.dateOfIssue.isNotEmpty) ...[
              context.verticalSpace(10),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 13, color: Colors.grey.shade400),
                  context.horizontalSpace(4),
                  Text(
                    rx.dateOfIssue,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const Spacer(),
                  Text(
                    'View Details →',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Prescription Detail Screen
// ─────────────────────────────────────────────────────────────────────────────

class PrescriptionDetailScreen extends StatefulWidget {
  final dynamic prescription;

  const PrescriptionDetailScreen({super.key, required this.prescription});

  @override
  State<PrescriptionDetailScreen> createState() =>
      _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState
    extends State<PrescriptionDetailScreen> {
  String? _resolvedDoctorName;
  String? _resolvedSpecialization;
  bool _loadingDoctor = false;

  @override
  void initState() {
    super.initState();
    _fetchDoctorIfNeeded();
  }

  Future<void> _fetchDoctorIfNeeded() async {
    final rx = widget.prescription;
    final doctorId = rx.doctor.id as int;
    final name = rx.doctor.name as String;

    // Only fetch if name is missing or is a placeholder
    if (doctorId > 0 &&
        (name.isEmpty || name.startsWith('Doctor #'))) {
      setState(() => _loadingDoctor = true);
      try {
        final api = ApiService();
        final res = await api.get('/api/Doctors/$doctorId');
        final data = res.data as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _resolvedDoctorName = (data['fullName'] ??
                    data['FullName'] ??
                    '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}')
                .toString()
                .trim();
            _resolvedSpecialization =
                (data['specialization'] ?? data['Specialization'])
                    ?.toString();
            _loadingDoctor = false;
          });
        }
      } catch (_) {
        if (mounted) setState(() => _loadingDoctor = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rx = widget.prescription;
    final doctorName = _resolvedDoctorName ??
        (rx.doctor.name.isNotEmpty && !rx.doctor.name.startsWith('Doctor #')
            ? rx.doctor.name
            : null);
    final specialization =
        _resolvedSpecialization ?? rx.doctor.specialization;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: 'Prescription Details'),
              context.verticalSpace(20),

              // ── Doctor Header ─────────────────────────────────────────
              _loadingDoctor
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : PrescriptionHeader(
                      doctorName: doctorName ?? 'Doctor',
                      speciality: specialization,
                      date: rx.dateOfIssue,
                      prescriptionId: rx.id,
                      doctorImageUrl: rx.doctor.pictureUrl,
                    ),

              context.verticalSpace(24),

              // ── Medications ────────────────────────────────────────────
              Row(
                children: [
                  Text('Medications', style: AppTextStyles.reg20black),
                  context.horizontalSpace(8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: rx.status.toLowerCase() == 'active'
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      rx.status.toUpperCase(),
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: rx.status.toLowerCase() == 'active'
                            ? Colors.green.shade800
                            : Colors.grey.shade700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              context.verticalSpace(10),

              ...rx.medications.map<Widget>((med) => MedicationItem(
                    name: med.name,
                    dosage: '${med.dosage} · ${med.form}',
                    duration: '${med.durationDays} Days',
                    instructions: med.instructions,
                  )),

              context.verticalSpace(20),

              // ── Doctor Notes ───────────────────────────────────────────
              if (rx.doctorNotes.isNotEmpty)
                DoctorNotesSection(
                  notes: rx.doctorNotes,
                  doctorName: doctorName ?? 'Doctor',
                ),

              context.verticalSpace(30),

              // ── Download button ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Download feature coming soon')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: Text(
                    'Download PDF',
                    style: AppTextStyles.semiBold16Black
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),

              context.verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}
