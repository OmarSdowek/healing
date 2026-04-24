import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/doctor/prescription/data/repo/prescription_repo_impl.dart';
import 'package:healing/features/doctor/prescription/domin/use_cases/add_prescription_use_case.dart';
import 'package:healing/features/doctor/prescription/presentation/manger/prescription_cubit.dart';
import 'package:healing/features/doctor/prescription/presentation/widgets/digital_signature_pad.dart';
import 'package:healing/features/doctor/prescription/presentation/widgets/medication_details_form.dart';
import 'package:healing/features/doctor/prescription/presentation/widgets/patient_summary_card.dart';

class AddPrescriptionScreen extends StatefulWidget {
  final String patientName;
  final int patientAge;
  final String patientMrn;
  final String patientBloodType;
  final String patientWeight;
  final String patientImage;
  // medicalRecordId is needed to POST to the API
  final int? medicalRecordId;

  const AddPrescriptionScreen({
    super.key,
    required this.patientName,
    required this.patientAge,
    required this.patientMrn,
    required this.patientBloodType,
    required this.patientWeight,
    required this.patientImage,
    this.medicalRecordId,
  });

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _medicationNameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrescriptionCubit(
        AddPrescriptionUseCase(PrescriptionRepoImpl(ApiService())),
      ),
      child: BlocListener<PrescriptionCubit, PrescriptionState>(
        listener: (context, state) {
          if (state is PrescriptionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Prescription added successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state is PrescriptionError) {
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
                CustomHeader(title: "New Prescription"),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(20),
                      vertical: context.h(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel("Patient Summary"),
                        context.verticalSpace(10),
                        PatientSummaryCard(
                          name: widget.patientName,
                          age: widget.patientAge,
                          mrn: widget.patientMrn,
                          bloodType: widget.patientBloodType,
                          weight: widget.patientWeight,
                          imageAsset: widget.patientImage,
                        ),
                        context.verticalSpace(20),
                        _SectionLabel("Medication Details"),
                        context.verticalSpace(10),
                        MedicationDetailsForm(
                          medicationNameController: _medicationNameController,
                          dosageController: _dosageController,
                          frequencyController: _frequencyController,
                          durationController: _durationController,
                        ),
                        context.verticalSpace(20),
                        _SectionLabel("NOTES & INSTRUCTIONS"),
                        context.verticalSpace(10),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          style: AppTextStyles.semiBold16Black.copyWith(
                            fontSize: context.sp(13),
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                "Take with food. Avoid alcohol during the course.",
                            hintStyle: AppTextStyles.semiBold16Black.copyWith(
                              fontSize: context.sp(13),
                              color: AppColors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        context.verticalSpace(20),
                        _SectionLabel("DIGITAL SIGNATURE"),
                        context.verticalSpace(10),
                        const DigitalSignaturePad(),
                        context.verticalSpace(28),
                        BlocBuilder<PrescriptionCubit, PrescriptionState>(
                          builder: (context, state) {
                            if (state is PrescriptionLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CustomButton(
                              text: "Done",
                              backgroundColor: AppColors.primary,
                              onPressed: () {
                                if (widget.medicalRecordId != null) {
                                  context
                                      .read<PrescriptionCubit>()
                                      .addPrescription(
                                        medicalRecordId:
                                            widget.medicalRecordId!,
                                        medicationName:
                                            _medicationNameController.text,
                                        dosage: _dosageController.text,
                                        frequency: _frequencyController.text,
                                        durationDays:
                                            int.tryParse(
                                              _durationController.text
                                                  .replaceAll(
                                                    RegExp(r'[^0-9]'),
                                                    '',
                                                  ),
                                            ) ??
                                            7,
                                        instructions:
                                            _notesController.text.isEmpty
                                            ? null
                                            : _notesController.text,
                                      );
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                        ),
                        context.verticalSpace(16),
                      ],
                    ),
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.semiBold24dark.copyWith(
        fontSize: context.sp(16),
        color: AppColors.primaryText,
      ),
    );
  }
}
