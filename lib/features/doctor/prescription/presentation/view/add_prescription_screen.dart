import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import '../../../appointments/domain/models/patient_summary_args.dart';
import '../../../medical_record/data/repositories/medical_record_repo_impl.dart';
import '../../../medical_record/domain/entities/medical_record_request.dart';
import '../../../medical_record/presentation/cubit/medical_record_cubit.dart';

const _kPrimary = Color(0xFF1E3A8A);
const _kBg = Color(0xFFF8FAFF);

// ─────────────────────────────────────────────────────────────────────────────
// Screen — responsible only for providing the cubit and routing to the form
// ─────────────────────────────────────────────────────────────────────────────

class AddPrescriptionScreen extends StatelessWidget {
  final Map<String, dynamic>? initialArgs;
  const AddPrescriptionScreen({super.key, this.initialArgs});

  @override
  Widget build(BuildContext context) {
    // Use initialArgs passed via constructor (more reliable than ModalRoute in listeners)
    final args = initialArgs ??
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('🔍 AddPrescriptionScreen args: $args');

    return BlocProvider(
      create: (_) => DoctorMedicalRecordCubit(
        DoctorMedicalRecordRepoImpl(ApiService()),
      ),
      child: _PrescriptionForm(args: args),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form — responsible for state management, validation, and navigation
// ─────────────────────────────────────────────────────────────────────────────

class _PrescriptionForm extends StatefulWidget {
  final Map<String, dynamic>? args;
  const _PrescriptionForm({this.args});

  @override
  State<_PrescriptionForm> createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<_PrescriptionForm> {
  final _medicationNameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _frequencyCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _expiresAtCtrl = TextEditingController();

  late PatientSummaryArgs _patient;
  bool _detailsFetched = false;
  bool _argsInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only parse args ONCE — prevent reset on rebuild
    if (!_argsInitialized) {
      _argsInitialized = true;
      // Use args passed from parent (ModalRoute not reliable in child widgets)
      final args = widget.args;
      _patient = PatientSummaryArgs.fromRouteArgs(args);
      print('🔍 Prescription args: recordId=${_patient.recordId}, patientId=${_patient.patientId}, patientName=${_patient.patientName}');
    }

    if (_expiresAtCtrl.text.isEmpty) {
      final expiry = DateTime.now().add(const Duration(days: 30));
      _expiresAtCtrl.text =
          '${expiry.year}-${expiry.month.toString().padLeft(2, '0')}-${expiry.day.toString().padLeft(2, '0')}';
    }

    if (!_detailsFetched && _patient.needsDetailsFetch) {
      _detailsFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context
              .read<DoctorMedicalRecordCubit>()
              .loadPatientDetails(_patient.patientId!);
        }
      });
    }
  }

  @override
  void dispose() {
    _medicationNameCtrl.dispose();
    _dosageCtrl.dispose();
    _frequencyCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    _expiresAtCtrl.dispose();
    super.dispose();
  }

  void _onPatientDetailsLoaded(
      BuildContext context, PatientDetailsLoadedState state) {
    final d = state.details;
    setState(() {
      _patient = _patient.copyWithDetails(
        fullName: d.fullName,
        mrn: d.medicalRecordNumber,
        bloodType: d.bloodType,
        dateOfBirth: d.dateOfBirth,
      );
    });
  }

  void _submit(BuildContext context) {
    // Guard: recordId must exist and be valid to save prescription
    if (_patient.recordId == null || _patient.recordId == 0) {
      AppSnackBar.showWarning(context,
          'No medical record found. Please create a medical record first.');
      return;
    }

    if (_medicationNameCtrl.text.trim().isEmpty ||
        _dosageCtrl.text.trim().isEmpty ||
        _frequencyCtrl.text.trim().isEmpty ||
        _durationCtrl.text.trim().isEmpty) {
      AppSnackBar.showWarning(context,
          'Please fill in all required fields: medication name, dosage, frequency, and duration.');
      return;
    }

    context.read<DoctorMedicalRecordCubit>().addPrescription(
          _patient.recordId!,
          AddPrescriptionRequest(
            medicationName: _medicationNameCtrl.text.trim(),
            dosage: _dosageCtrl.text.trim(),
            frequency: _frequencyCtrl.text.trim(),
            durationDays: int.tryParse(_durationCtrl.text.trim()) ?? 7,
            instructions: _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
            expiresAt: _expiresAtCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorMedicalRecordCubit, DoctorMedicalRecordState>(
      listener: (context, state) {
        if (state is PatientDetailsLoaded) {
          _onPatientDetailsLoaded(context, state);
        } else if (state is DoctorMedicalRecordSuccess) {
          AppSnackBar.showSuccess(context, state.message);
          if (_patient.recordId != null) {
            Navigator.pushReplacementNamed(
              context,
              Routes.addVitals,
              arguments: {
                'recordId': _patient.recordId!,
                'patientName': _patient.patientName,
              },
            );
          } else {
            Navigator.pop(context);
          }
        } else if (state is DoctorMedicalRecordError) {
          AppSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is DoctorMedicalRecordLoading;
        return Scaffold(
          backgroundColor: _kBg,
          body: SafeArea(
            child: Column(
              children: [
                _PrescriptionHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('Patient Summary'),
                        context.verticalSpace(8),
                        _PatientSummaryCard(patient: _patient),
                        context.verticalSpace(20),
                        _SectionLabel('Medication Details'),
                        context.verticalSpace(8),
                        _MedicationDetailsCard(
                          nameCtrl: _medicationNameCtrl,
                          dosageCtrl: _dosageCtrl,
                          frequencyCtrl: _frequencyCtrl,
                          durationCtrl: _durationCtrl,
                        ),
                        context.verticalSpace(20),
                        _SectionLabel('Notes & Instructions'),
                        context.verticalSpace(8),
                        _WhiteCard(
                          child: TextFormField(
                            controller: _notesCtrl,
                            maxLines: 4,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF374151)),
                            decoration: InputDecoration(
                              hintText:
                                  'Take with food. Avoid cold drinks during the course.',
                              hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade400),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        context.verticalSpace(20),
                        _SectionLabel('Digital Signature'),
                        context.verticalSpace(8),
                        _WhiteCard(
                          child: DottedBorderBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.draw_outlined,
                                    color: _kPrimary.withOpacity(0.5),
                                    size: 28),
                                const SizedBox(height: 8),
                                const Text(
                                  'Sign Here Or Saved Signature',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: _kPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        context.verticalSpace(28),
                        _PrescriptionActions(
                          isLoading: isLoading,
                          hasRecord: _patient.recordId != null,
                          onSave: () => _submit(context),
                          onSkip: _patient.recordId != null
                              ? () => Navigator.pushReplacementNamed(
                                    context,
                                    Routes.addVitals,
                                    arguments: {
                                      'recordId': _patient.recordId!,
                                      'patientName': _patient.patientName,
                                    },
                                  )
                              : () => Navigator.pop(context),
                        ),
                        context.verticalSpace(24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets — each has a single display responsibility
// ─────────────────────────────────────────────────────────────────────────────

class _PrescriptionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: context.w(8), vertical: context.h(10)),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Color(0xFF1F2937), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'New Prescription',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _kPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.science_outlined,
                color: _kPrimary, size: 20),
          ),
          context.horizontalSpace(8),
        ],
      ),
    );
  }
}

class _PatientSummaryCard extends StatelessWidget {
  final PatientSummaryArgs patient;
  const _PatientSummaryCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    // "Age: 34 | MRN: #MRN-29384" — matches mockup format
    final infoParts = <String>[];
    if (patient.patientAge != null) infoParts.add('Age: ${patient.patientAge}');
    if (patient.patientMrn != null) infoParts.add('MRN: #${patient.patientMrn}');
    final subtitle = infoParts.join(' | ');

    return _WhiteCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: _kPrimary.withOpacity(0.1),
            child: const Icon(Icons.person, color: _kPrimary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.patientName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280))),
                ],
                if (patient.patientBloodType != null ||
                    patient.patientWeight != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (patient.patientBloodType != null)
                        _InfoChip(
                          label: 'Blood: ${patient.patientBloodType}',
                          bgColor: const Color(0xFFFFE4E6),
                          textColor: const Color(0xFFDC2626),
                        ),
                      if (patient.patientBloodType != null &&
                          patient.patientWeight != null)
                        const SizedBox(width: 8),
                      if (patient.patientWeight != null)
                        _InfoChip(
                          label: 'Weight: ${patient.patientWeight}',
                          bgColor: const Color(0xFFDBEAFE),
                          textColor: const Color(0xFF1D4ED8),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationDetailsCard extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController dosageCtrl;
  final TextEditingController frequencyCtrl;
  final TextEditingController durationCtrl;

  const _MedicationDetailsCard({
    required this.nameCtrl,
    required this.dosageCtrl,
    required this.frequencyCtrl,
    required this.durationCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Medication Name'),
          context.verticalSpace(6),
          _StyledTextField(
              controller: nameCtrl,
              hint: 'Amoxicillin 500mg',
              suffixIcon: Icons.search),
          context.verticalSpace(14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Dosage'),
                    context.verticalSpace(6),
                    _StyledTextField(controller: dosageCtrl, hint: '1 tablet'),
                  ],
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Frequency'),
                    context.verticalSpace(6),
                    _StyledTextField(
                        controller: frequencyCtrl, hint: 'Twice daily'),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(14),
          const _FieldLabel('Duration'),
          context.verticalSpace(6),
          _StyledTextField(
            controller: durationCtrl,
            hint: '7 days',
            suffixIcon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class _PrescriptionActions extends StatelessWidget {
  final bool isLoading;
  final bool hasRecord;
  final VoidCallback onSave;
  final VoidCallback onSkip;

  const _PrescriptionActions({
    required this.isLoading,
    required this.hasRecord,
    required this.onSave,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: _kPrimary));
    }
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              hasRecord ? 'Save Prescription' : 'Done',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        if (hasRecord) ...[
          context.verticalSpace(12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: onSkip,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _kPrimary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Skip — Add Vitals',
                style: TextStyle(
                    color: _kPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared primitive widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937)),
      );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151)),
      );
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      );
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kPrimary, width: 1.5),
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, size: 18, color: Colors.grey.shade400)
              : null,
          isDense: true,
        ),
      );
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _InfoChip({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
        ),
      );
}

class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _DashedBorderPainter(),
        child: SizedBox(
          width: double.infinity,
          height: 90,
          child: Center(child: child),
        ),
      );
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = _kPrimary.withOpacity(0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
            metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alias for state type used in listener
typedef PatientDetailsLoadedState = PatientDetailsLoaded;
