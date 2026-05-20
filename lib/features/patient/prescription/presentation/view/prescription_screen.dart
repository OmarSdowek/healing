import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/patient/medical_report/domin/entity/prescription_entity.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../manger/prescription_cubit/prescription_cubit.dart';
import 'prescription_details.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientAuthCubit>(
      create: (_) => sl<PatientAuthCubit>()..meData(),
      child: BlocBuilder<PatientAuthCubit, PatientAuthState>(
        builder: (ctx, authState) {
          if (authState is! PatientDataSuccess) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final patientId =
              int.tryParse(authState.meData.patientId ?? '0') ?? 0;

          if (patientId == 0) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return BlocProvider<PrescriptionCubit>(
            key: ValueKey('prescriptions_$patientId'),
            create: (_) =>
                sl<PrescriptionCubit>()..loadPrescriptions(patientId),
            child: _PrescriptionView(patientId: patientId),
          );
        },
      ),
    );
  }
}

class _PrescriptionView extends StatelessWidget {
  final int patientId;
  const _PrescriptionView({required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: 'My Prescriptions'),
            Expanded(
              child: BlocBuilder<PrescriptionCubit, PrescriptionState>(
                builder: (context, state) {
                  if (state is PrescriptionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PrescriptionError) {
                    return _ErrorView(message: state.message);
                  }

                  if (state is PrescriptionLoaded) {
                    if (state.prescriptions.isEmpty) {
                      return const _EmptyView();
                    }
                    return _PrescriptionList(
                        prescriptions: state.prescriptions,
                        patientId: patientId);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No prescriptions yet',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionList extends StatelessWidget {
  final List<PrescriptionEntity> prescriptions;
  final int patientId;
  const _PrescriptionList({required this.prescriptions, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: prescriptions.length,
      itemBuilder: (context, i) {
        final rx = prescriptions[i];
        return PrescriptionListCard(
          prescription: rx,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PrescriptionCubit>(),
                child: PrescriptionDetailScreen(
                  prescription: rx,
                  patientId: patientId,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Prescription List Card ───────────────────────────────────────────────────

class PrescriptionListCard extends StatelessWidget {
  final PrescriptionEntity prescription;
  final VoidCallback onTap;

  const PrescriptionListCard({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
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
    final statusColor = _statusColor(prescription.status);
    final firstMed =
        prescription.medications.isNotEmpty ? prescription.medications.first : null;
    final doctorName = prescription.doctor.name.isNotEmpty &&
            !prescription.doctor.name.startsWith('Doctor #')
        ? 'Dr. ${prescription.doctor.name}'
        : 'Prescribing Doctor';

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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor row ──────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person,
                      color: AppColors.primary, size: 24),
                ),
                context.horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctorName, style: AppTextStyles.semiBold16Black),
                      if (prescription.doctor.specialization.isNotEmpty)
                        Text(
                          prescription.doctor.specialization,
                          style: AppTextStyles.semiBold16Black.copyWith(
                              color: Colors.grey, fontSize: 13),
                        ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prescription.status.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor),
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            // ── First medication preview ─────────────────────────────────
            if (firstMed != null)
              Row(
                children: [
                  const Icon(Icons.medication_outlined,
                      size: 16, color: AppColors.primary),
                  context.horizontalSpace(8),
                  Expanded(
                    child: Text(
                      firstMed.name,
                      style: AppTextStyles.semiBold16Black
                          .copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${firstMed.durationDays} days',
                    style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.primary, fontSize: 13),
                  ),
                ],
              ),

            if (prescription.medications.length > 1) ...[
              context.verticalSpace(4),
              Text(
                '+${prescription.medications.length - 1} more medication(s)',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],

            // ── Date ────────────────────────────────────────────────────
            if (prescription.dateOfIssue.isNotEmpty) ...[
              context.verticalSpace(10),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 13, color: Colors.grey.shade400),
                  context.horizontalSpace(4),
                  Text(
                    prescription.dateOfIssue,
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
