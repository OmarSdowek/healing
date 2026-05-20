import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/patient/medical_report/domin/entity/prescription_entity.dart';
import 'package:open_file/open_file.dart';
import '../manger/prescription_cubit/prescription_cubit.dart';
import '../widgets/doctor_notes_section.dart';
import '../widgets/mediction_item.dart';
import '../widgets/prescription_header.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final PrescriptionEntity prescription;
  final int patientId;

  const PrescriptionDetailScreen({
    super.key,
    required this.prescription,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = prescription.doctor.name.isNotEmpty &&
            !prescription.doctor.name.startsWith('Doctor #')
        ? prescription.doctor.name
        : 'Unknown Doctor';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: BlocListener<PrescriptionCubit, PrescriptionState>(
          listener: (context, state) {
            if (state is PrescriptionPdfDownloaded) {
              // Open the file immediately after download
              OpenFile.open(state.filePath);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF downloaded successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is PrescriptionPdfError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: 'Prescription Details'),
                context.verticalSpace(20),

                // ── Doctor Header ────────────────────────────────────────
                PrescriptionHeader(
                  doctorName: doctorName,
                  speciality: prescription.doctor.specialization,
                  date: prescription.dateOfIssue,
                  prescriptionId: prescription.id,
                  doctorImageUrl: prescription.doctor.pictureUrl,
                ),

                context.verticalSpace(24),

                // ── Medications ──────────────────────────────────────────
                Row(
                  children: [
                    Text('Medications', style: AppTextStyles.reg20black),
                    context.horizontalSpace(8),
                    _StatusBadge(status: prescription.status),
                  ],
                ),
                context.verticalSpace(10),

                ...prescription.medications.map(
                  (med) => MedicationItem(
                    name: med.name,
                    dosage: '${med.dosage} · ${med.form}',
                    duration: '${med.durationDays} Days',
                    instructions: med.instructions,
                  ),
                ),

                context.verticalSpace(20),

                // ── Doctor Notes ─────────────────────────────────────────
                if (prescription.doctorNotes.isNotEmpty)
                  DoctorNotesSection(
                    notes: prescription.doctorNotes,
                    doctorName: doctorName,
                  ),

                context.verticalSpace(30),

                // ── Download button ──────────────────────────────────────
                BlocBuilder<PrescriptionCubit, PrescriptionState>(
                  builder: (context, state) {
                    final isDownloading =
                        state is PrescriptionPdfDownloading;
                    return SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: isDownloading
                            ? 'Downloading...'
                            : 'Download PDF',
                        icon: isDownloading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.download,
                                color: AppColors.white),
                        onPressed: isDownloading
                            ? () {} // disabled — no-op while downloading
                            : () => context
                                .read<PrescriptionCubit>()
                                .downloadPdf(
                                  patientId: patientId,
                                  prescriptionId: prescription.id,
                                ),
                      ),
                    );
                  },
                ),

                context.verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.semiBold16Black.copyWith(
          color: isActive ? Colors.green.shade800 : Colors.grey.shade700,
          fontSize: 11,
        ),
      ),
    );
  }
}
