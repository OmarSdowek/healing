import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import '../../data/repositories/lab_order_repository_impl.dart';
import '../../domain/usecases/create_lab_order_usecase.dart';
import '../cubit/lab_order_cubit.dart';
import '../../../appointments/domain/models/patient_summary_args.dart';
import '../../../medical_record/data/repositories/medical_record_repo_impl.dart';
import '../../../medical_record/presentation/cubit/medical_record_cubit.dart';

const _kPrimary = Color(0xFF1E3A8A);
const _kBg = Color(0xFFF8FAFF);

const _kLabTests = [
  'CBC Panel',
  'Lipid Profile',
  'Thyroid Panel',
  'Glucose Fast',
  'Liver Function',
  'Kidney Function',
  'HbA1c',
  'Urine Analysis',
  'Blood Culture',
  'Vitamin D',
  'Iron Studies',
  'Coagulation Panel',
];

// ─────────────────────────────────────────────────────────────────────────────
// Screen — provides cubits
// ─────────────────────────────────────────────────────────────────────────────

class LabOrderScreen extends StatelessWidget {
  const LabOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LabOrderCubit(
            CreateLabOrderUseCase(LabOrderRepositoryImpl(ApiService())),
          ),
        ),
        BlocProvider(
          create: (_) => DoctorMedicalRecordCubit(
            DoctorMedicalRecordRepoImpl(ApiService()),
          ),
        ),
      ],
      child: const _LabOrderForm(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form
// ─────────────────────────────────────────────────────────────────────────────

class _LabOrderForm extends StatefulWidget {
  const _LabOrderForm();

  @override
  State<_LabOrderForm> createState() => _LabOrderFormState();
}

class _LabOrderFormState extends State<_LabOrderForm> {
  final _indicationCtrl = TextEditingController();
  String _priority = 'Routine';
  late PatientSummaryArgs _patient;
  bool _detailsFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _patient = PatientSummaryArgs.fromRouteArgs(args);

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
    _indicationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorMedicalRecordCubit, DoctorMedicalRecordState>(
      listener: (context, state) {
        if (state is PatientDetailsLoaded) {
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
      },
      child: BlocConsumer<LabOrderCubit, LabOrderState>(
        listener: (context, state) {
          if (state is LabOrderSuccess) {
            _LabOrderSuccessDialog.show(context, state);
          } else if (state is LabOrderError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final selected =
              state is LabOrderSelecting ? state.selectedTests : <String>{};
          final isLoading = state is LabOrderLoading;

          return Scaffold(
            backgroundColor: _kBg,
            body: SafeArea(
              child: Column(
                children: [
                  const _LabOrderHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Patient Card ─────────────────────────────
                          _PatientCard(patient: _patient),
                          const SizedBox(height: 22),

                          // ── Test Selection ───────────────────────────
                          _TestSelectionSection(selected: selected),
                          const SizedBox(height: 22),

                          // ── Clinical Instruction ─────────────────────
                          _ClinicalInstructionField(ctrl: _indicationCtrl),
                          const SizedBox(height: 22),

                          // ── Priority ─────────────────────────────────
                          _PrioritySelector(
                            selected: _priority,
                            onChanged: (p) => setState(() => _priority = p),
                          ),
                          const SizedBox(height: 30),

                          // ── Submit ────────────────────────────────────
                          _SubmitButton(
                            isLoading: isLoading,
                            onPressed: () {
                              context.read<LabOrderCubit>().submitOrder(
                                    recordId: _patient.recordId ?? 0,
                                    clinicalIndication:
                                        _indicationCtrl.text.trim(),
                                    priority: _priority,
                                  );
                            },
                          ),
                          const SizedBox(height: 24),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _LabOrderHeader extends StatelessWidget {
  const _LabOrderHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Color(0xFF1F2937), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Medical tests',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937)),
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
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Patient Card — matches mockup: avatar + name + "Age: X | MRN: #X" + chips
// ─────────────────────────────────────────────────────────────────────────────

class _PatientCard extends StatelessWidget {
  final PatientSummaryArgs patient;
  const _PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final infoParts = <String>[];
    if (patient.patientAge != null) infoParts.add('Age: ${patient.patientAge}');
    if (patient.patientMrn != null) infoParts.add('MRN: #${patient.patientMrn}');
    final subtitle = infoParts.join(' | ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
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
                Text(patient.patientName,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937))),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280))),
                ],
                if (patient.patientBloodType != null ||
                    patient.patientWeight != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (patient.patientBloodType != null)
                        _Chip(
                          label: 'Blood: ${patient.patientBloodType}',
                          bgColor: const Color(0xFFFFE4E6),
                          textColor: const Color(0xFFDC2626),
                        ),
                      if (patient.patientWeight != null)
                        _Chip(
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

// ─────────────────────────────────────────────────────────────────────────────
// Test Selection — Wrap chips with ⊕ icon (matches mockup)
// ─────────────────────────────────────────────────────────────────────────────

class _TestSelectionSection extends StatelessWidget {
  final Set<String> selected;
  const _TestSelectionSection({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Test Selection',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937))),
            GestureDetector(
              onTap: () {},
              child: const Text('See All',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kPrimary)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Search bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade400, size: 20),
              const SizedBox(width: 10),
              Text('Search lab tests...',
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey.shade400)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Test chips — outlined style with ⊕ / ✓ icon (matches mockup)
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _kLabTests.map((test) {
            final isSelected = selected.contains(test);
            return GestureDetector(
              onTap: () =>
                  context.read<LabOrderCubit>().toggleTest(test),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _kPrimary.withOpacity(0.07)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? _kPrimary
                        : const Color(0xFFE5E7EB),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_outline
                          : Icons.add_circle_outline,
                      size: 16,
                      color: isSelected
                          ? _kPrimary
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      test,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? _kPrimary
                            : const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Clinical Instruction
// ─────────────────────────────────────────────────────────────────────────────

class _ClinicalInstructionField extends StatelessWidget {
  final TextEditingController ctrl;
  const _ClinicalInstructionField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Clinical Instruction',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3))
            ],
          ),
          child: TextFormField(
            controller: ctrl,
            maxLines: 5,
            style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
            decoration: InputDecoration(
              hintText:
                  'Write your Add specific instructions or reasoning for this order...',
              hintStyle:
                  TextStyle(fontSize: 12, color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Priority Selector
// ─────────────────────────────────────────────────────────────────────────────

class _PrioritySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PrioritySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Priority',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937))),
        const SizedBox(height: 8),
        Row(
          children: ['Routine', 'Urgent', 'STAT']
              .map((p) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => onChanged(p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: selected == p ? _kPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected == p
                                ? _kPrimary
                                : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected == p
                                ? Colors.white
                                : const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Submit Button
// ─────────────────────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: _kPrimary));
    }
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text('Create Lab Order',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success Dialog — matches mockup exactly
// ─────────────────────────────────────────────────────────────────────────────

class _LabOrderSuccessDialog {
  _LabOrderSuccessDialog._();

  static void show(BuildContext context, LabOrderSuccess state) {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dateStr =
        'Today, ${months[now.month - 1]} ${now.day}, ${now.year}';
    final refStr =
        'Ref: ${state.order.id?.toString().padLeft(3, '0') ?? '882'}-CLM-01';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green check circle
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF16A34A), size: 50),
              ),
              const SizedBox(height: 16),

              // Title
              const Text('Lab Order Submitted',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937))),
              const SizedBox(height: 20),

              // Requested tests label
              const Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.science_outlined,
                        size: 14, color: Color(0xFF9CA3AF)),
                    SizedBox(width: 6),
                    Text('REQUESTED TESTS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9CA3AF),
                            letterSpacing: 0.8)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Test chips
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.order.tests
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(t,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1D4ED8))),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              const SizedBox(height: 14),

              // Date row
              _DialogRow(
                  icon: Icons.calendar_today_outlined, text: dateStr),
              const SizedBox(height: 6),

              // Ref row
              _DialogRow(icon: Icons.description_outlined, text: refStr),
              const SizedBox(height: 22),

              // Done button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // go back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DialogRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF6B7280))),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _Chip({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor)),
      );
}
