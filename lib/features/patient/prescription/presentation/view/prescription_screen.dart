import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../../medical_report/presentation/manger/medical_report_cubit.dart';
import '../widgets/doctor_notes_section.dart';
import '../widgets/mediction_item.dart';
import '../widgets/prescription_header.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap with PatientAuthCubit in case it's not in the ancestor tree
    return BlocProvider<PatientAuthCubit>(
      create: (_) => sl<PatientAuthCubit>()..meData(),
      child: BlocBuilder<PatientAuthCubit, PatientAuthState>(
        builder: (ctx, authState) {
          int patientId = 1;
          if (authState is PatientDataSuccess) {
            patientId =
                int.tryParse(authState.meData.patientId ?? '1') ?? 1;
          }

          return BlocProvider<MedicalReportCubit>(
            key: ValueKey(patientId),
            create: (_) =>
                sl<MedicalReportCubit>()..loadPrescriptions(patientId),
            child: Scaffold(
              body: SafeArea(
                child: BlocBuilder<MedicalReportCubit, MedicalReportState>(
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.medication_outlined,
                                  size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                "No prescriptions yet",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        );
                      }

                      final rx = state.prescriptions.first;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomHeader(title: "Prescription Details"),
                            context.verticalSpace(20),

                            PrescriptionHeader(
                              doctorName: rx.doctor.name,
                              speciality: rx.doctor.specialization,
                              date: rx.dateOfIssue,
                              prescriptionId: rx.id,
                              doctorImageUrl: rx.doctor.pictureUrl,
                            ),
                            context.verticalSpace(20),

                            Row(
                              children: [
                                Text("Medications",
                                    style: AppTextStyles.reg20black),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    rx.status.toUpperCase(),
                                    style: AppTextStyles.semiBold16Black
                                        .copyWith(
                                            color: Colors.green.shade800,
                                            fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                            context.verticalSpace(10),

                            ...rx.medications.map((med) => MedicationItem(
                                  name: med.name,
                                  dosage: "${med.dosage} • ${med.form}",
                                  duration: "${med.durationDays} Days",
                                  instructions: med.instructions,
                                )),

                            context.verticalSpace(20),

                            DoctorNotesSection(
                              notes: rx.doctorNotes,
                              doctorName: rx.doctor.name,
                            ),

                            context.verticalSpace(30),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Download feature coming soon")),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.download,
                                    color: Colors.white),
                                label: Text(
                                  "Download PDF",
                                  style: AppTextStyles.semiBold16Black
                                      .copyWith(color: Colors.white),
                                ),
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
            ),
          );
        },
      ),
    );
  }
}
