import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/helper/jwt_helper.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../data/repositories/medical_record_repo_impl.dart';
import '../cubit/medical_record_cubit.dart';

class PatientDetailsScreen extends StatelessWidget {
  final int patientId;
  final int appointmentId;
  final String patientName;

  const PatientDetailsScreen({
    super.key,
    required this.patientId,
    required this.appointmentId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorMedicalRecordCubit(
        DoctorMedicalRecordRepoImpl(ApiService()),
      )..loadPatientDetails(patientId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: SafeArea(
          child: Column(
            children: [
              const CustomHeader(title: "Patient Details"),
              Expanded(
                child: BlocBuilder<DoctorMedicalRecordCubit,
                    DoctorMedicalRecordState>(
                  builder: (context, state) {
                    if (state is DoctorMedicalRecordLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is DoctorMedicalRecordError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 12),
                            Text(state.message, textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<DoctorMedicalRecordCubit>()
                                  .loadPatientDetails(patientId),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is PatientDetailsLoaded) {
                      final p = state.details;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Patient Card ──────────────────────────────
                            _InfoCard(
                              children: [
                                _InfoRow(
                                    icon: Icons.person,
                                    label: "Name",
                                    value: p.fullName),
                                if (p.medicalRecordNumber != null)
                                  _InfoRow(
                                      icon: Icons.badge,
                                      label: "MRN",
                                      value: p.medicalRecordNumber!),
                                if (p.dateOfBirth != null)
                                  _InfoRow(
                                      icon: Icons.cake,
                                      label: "DOB",
                                      value: p.dateOfBirth!),
                                if (p.gender != null)
                                  _InfoRow(
                                      icon: Icons.wc,
                                      label: "Gender",
                                      value: p.gender!),
                                if (p.phone != null)
                                  _InfoRow(
                                      icon: Icons.phone,
                                      label: "Phone",
                                      value: p.phone!),
                                if (p.bloodType != null)
                                  _InfoRow(
                                      icon: Icons.bloodtype,
                                      label: "Blood Type",
                                      value: p.bloodType!,
                                      valueColor: Colors.red),
                              ],
                            ),

                            context.verticalSpace(16),

                            // ── Allergies ─────────────────────────────────
                            if (p.allergies.isNotEmpty) ...[
                              Text("⚠️ Allergies",
                                  style: AppTextStyles.semiBold16Black
                                      .copyWith(color: Colors.red)),
                              context.verticalSpace(8),
                              _InfoCard(
                                children: p.allergies
                                    .map((a) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.warning_amber,
                                                  color: Colors.orange,
                                                  size: 16),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(a,
                                                    style: AppTextStyles
                                                        .semiBold16Black
                                                        .copyWith(
                                                            fontSize: 13)),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                              context.verticalSpace(16),
                            ],

                            // ── Medical History ───────────────────────────
                            if (p.medicalHistories.isNotEmpty) ...[
                              Text("Medical History",
                                  style: AppTextStyles.semiBold16Black),
                              context.verticalSpace(8),
                              _InfoCard(
                                children: p.medicalHistories
                                    .map((h) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.medical_information,
                                                  color: AppColors.primary,
                                                  size: 16),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                  child: Text(h,
                                                      style: AppTextStyles
                                                          .semiBold16Black)),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                              context.verticalSpace(16),
                            ],

                            // ── Actions ───────────────────────────────────
                            CustomButton(
                              text: "Create Medical Record",
                              backgroundColor: AppColors.primary,
                              textColor: Colors.white,
                              onPressed: () async {
                                final doctorId = await JwtHelper.getDoctorId();
                                if (!context.mounted) return;
                                Navigator.pushNamed(
                                  context,
                                  Routes.createMedicalRecord,
                                  arguments: {
                                    'patientId': patientId,
                                    'appointmentId': appointmentId,
                                    'patientName': p.fullName,
                                    'doctorId': doctorId,
                                  },
                                );
                              },
                            ),
                            context.verticalSpace(12),
                            CustomButton(
                              text: "Order Lab Tests",
                              outlined: true,
                              textColor: AppColors.primary,
                              onPressed: () => Navigator.pushNamed(
                                context,
                                Routes.labOrder,
                                arguments: {
                                  'recordId': 0,
                                  'patientId': patientId,
                                  'patientName': p.fullName,
                                },
                              ),
                            ),
                          ],
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
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              "$label: ",
              style: AppTextStyles.semiBold16Black
                  .copyWith(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.semiBold16Black.copyWith(
                color: valueColor ?? AppColors.primaryText,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
