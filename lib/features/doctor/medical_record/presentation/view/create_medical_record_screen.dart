import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/services/gemini_service.dart';
import 'package:healing/core/widgets/ai_summary_sheet.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../data/repositories/medical_record_repo_impl.dart';
import '../../domain/entities/medical_record_request.dart';
import '../cubit/medical_record_cubit.dart';
import '../../../prescription/presentation/view/add_prescription_screen.dart';

class CreateMedicalRecordScreen extends StatefulWidget {
  final int patientId;
  final int appointmentId;
  final String patientName;
  final int doctorId;

  const CreateMedicalRecordScreen({
    super.key,
    required this.patientId,
    required this.appointmentId,
    required this.patientName,
    required this.doctorId,
  });

  @override
  State<CreateMedicalRecordScreen> createState() =>
      _CreateMedicalRecordScreenState();
}

class _CreateMedicalRecordScreenState
    extends State<CreateMedicalRecordScreen> {
  final _chiefComplaintCtrl = TextEditingController();
  final _diagnosisCtrl = TextEditingController();
  final _icdCodeCtrl = TextEditingController();
  final _clinicalNotesCtrl = TextEditingController();
  final _treatmentPlanCtrl = TextEditingController();
  final _followUpCtrl = TextEditingController();

  @override
  void dispose() {
    _chiefComplaintCtrl.dispose();
    _diagnosisCtrl.dispose();
    _icdCodeCtrl.dispose();
    _clinicalNotesCtrl.dispose();
    _treatmentPlanCtrl.dispose();
    _followUpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorMedicalRecordCubit(
        DoctorMedicalRecordRepoImpl(ApiService()),
      ),
      child: BlocConsumer<DoctorMedicalRecordCubit, DoctorMedicalRecordState>(
        listener: (context, state) {
          if (state is MedicalRecordCreated) {
            AppSnackBar.showSuccess(context, 'Medical record created successfully.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AddPrescriptionScreen(
                  initialArgs: {
                    'recordId': state.record.id,
                    'patientId': widget.patientId,
                    'patientName': widget.patientName,
                    'doctorId': widget.doctorId,
                  },
                ),
              ),
            );
          } else if (state is DoctorMedicalRecordError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is DoctorMedicalRecordLoading;

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FB),
            body: SafeArea(
              child: Column(
                children: [
                  const CustomHeader(title: "Medical Record"),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Patient info
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.person,
                                    color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(widget.patientName,
                                    style: AppTextStyles.semiBold16Black),
                              ],
                            ),
                          ),

                          context.verticalSpace(20),

                          _label("Chief Complaint *"),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: "Main symptom or reason for visit",
                            controller: _chiefComplaintCtrl,
                          ),

                          context.verticalSpace(16),

                          _label("Diagnosis *"),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: "e.g. Stable Angina Pectoris",
                            controller: _diagnosisCtrl,
                          ),

                          context.verticalSpace(16),

                          _label("ICD Code"),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: "e.g. I20.9",
                            controller: _icdCodeCtrl,
                          ),

                          context.verticalSpace(16),

                          _label("Clinical Notes"),
                          context.verticalSpace(8),
                          _multilineField(
                              _clinicalNotesCtrl, "Detailed clinical notes..."),

                          context.verticalSpace(16),

                          _label("Treatment Plan"),
                          context.verticalSpace(8),
                          _multilineField(
                              _treatmentPlanCtrl, "Treatment plan..."),

                          context.verticalSpace(16),

                          _label("Follow-up Date"),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: "YYYY-MM-DD",
                            controller: _followUpCtrl,
                            keyboardType: TextInputType.datetime,
                          ),

                          context.verticalSpace(32),

                          // ── AI Summary Button ──────────────────────────
                          OutlinedButton.icon(
                            icon: const Icon(Icons.auto_awesome,
                                color: AppColors.primary, size: 18),
                            label: const Text(
                              '✨ Generate AI Summary',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              final diagnosis =
                                  _diagnosisCtrl.text.trim();
                              if (diagnosis.isEmpty) {
                                AppSnackBar.showWarning(context,
                                    'Please enter the diagnosis first.');
                                return;
                              }
                              AiSummarySheet.show(
                                context,
                                title: 'Patient Visit Summary',
                                generateFn: () =>
                                    GeminiService.generateMedicalSummary(
                                  patientName: widget.patientName,
                                  diagnosis: diagnosis,
                                  clinicalNotes:
                                      _clinicalNotesCtrl.text.trim(),
                                  treatmentPlan:
                                      _treatmentPlanCtrl.text.trim(),
                                ),
                              );
                            },
                          ),

                          context.verticalSpace(12),

                          isLoading
                              ? const Center(
                                  child: CircularProgressIndicator())
                              : CustomButton(
                                  text: "Save & Add Prescription",
                                  backgroundColor: AppColors.primary,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (_chiefComplaintCtrl.text
                                            .trim()
                                            .isEmpty ||
                                        _diagnosisCtrl.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Chief complaint and diagnosis are required"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    context
                                        .read<DoctorMedicalRecordCubit>()
                                        .createRecord(
                                          CreateMedicalRecordRequest(
                                            patientId: widget.patientId,
                                            doctorId: widget.doctorId,
                                            appointmentId:
                                                widget.appointmentId,
                                            visitDate: _formatVisitDate(),
                                            chiefComplaint:
                                                _chiefComplaintCtrl.text
                                                    .trim(),
                                            diagnosis:
                                                _diagnosisCtrl.text.trim(),
                                            icdCode: _icdCodeCtrl.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _icdCodeCtrl.text.trim(),
                                            clinicalNotes: _clinicalNotesCtrl
                                                    .text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _clinicalNotesCtrl.text
                                                    .trim(),
                                            treatmentPlan: _treatmentPlanCtrl
                                                    .text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _treatmentPlanCtrl.text
                                                    .trim(),
                                            followUpDate: _followUpCtrl.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _followUpCtrl.text.trim(),
                                          ),
                                        );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Returns yesterday's date as "YYYY-MM-DD" to avoid timezone issues.
  /// The server validates visitDate is not in the future (UTC).
  /// Using yesterday guarantees it's always in the past regardless of timezone.
  String _formatVisitDate() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
  }

  Widget _label(String text) => Text(text,
      style: AppTextStyles.semiBold16Black.copyWith(fontSize: 14));

  Widget _multilineField(TextEditingController ctrl, String hint) {
    return TextFormField(
      controller: ctrl,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
