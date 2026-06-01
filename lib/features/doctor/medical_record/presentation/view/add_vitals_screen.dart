import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../data/repositories/medical_record_repo_impl.dart';
import '../../domain/entities/medical_record_request.dart';
import '../cubit/medical_record_cubit.dart';

class AddVitalsScreen extends StatefulWidget {
  const AddVitalsScreen({super.key});

  @override
  State<AddVitalsScreen> createState() => _AddVitalsScreenState();
}

class _AddVitalsScreenState extends State<AddVitalsScreen> {
  final _tempCtrl = TextEditingController();
  final _systolicCtrl = TextEditingController();
  final _diastolicCtrl = TextEditingController();
  final _heartRateCtrl = TextEditingController();
  final _respRateCtrl = TextEditingController();
  final _o2Ctrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  int? _recordId;
  String? _patientName;
  String _doctorName = 'Doctor';
  bool _argsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLoaded) {
      _argsLoaded = true;
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _recordId = args?['recordId'] as int?;
      _patientName = args?['patientName'] as String? ?? 'Patient';
      // Doctor name passed from previous screen if available
      final passedDoctorName = args?['doctorName'] as String?;
      if (passedDoctorName != null && passedDoctorName.isNotEmpty) {
        _doctorName = passedDoctorName;
      } else {
        // Fetch doctor name from /api/Auth/me in background
        _fetchDoctorName();
      }
    }
  }

  Future<void> _fetchDoctorName() async {
    try {
      final api = ApiService();
      final response = await api.get('/api/Auth/me');
      final data = response.data;
      final name = data is Map ? data['fullName']?.toString() : null;
      if (name != null && name.isNotEmpty && mounted) {
        setState(() => _doctorName = 'Dr. $name');
      }
    } catch (_) {
      // fallback stays as 'Doctor'
    }
  }

  @override
  void dispose() {
    _tempCtrl.dispose();
    _systolicCtrl.dispose();
    _diastolicCtrl.dispose();
    _heartRateCtrl.dispose();
    _respRateCtrl.dispose();
    _o2Ctrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
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
          if (state is DoctorMedicalRecordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Done — go back to home
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.doctorHome,
              (route) => false,
            );
          } else if (state is DoctorMedicalRecordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DoctorMedicalRecordLoading;

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FB),
            body: SafeArea(
              child: Column(
                children: [
                  const CustomHeader(title: "Vital Signs"),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_patientName != null)
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
                                  Text(_patientName!,
                                      style: AppTextStyles.semiBold16Black),
                                ],
                              ),
                            ),

                          context.verticalSpace(20),

                          _VitalField(
                              label: "Temperature (°C)",
                              ctrl: _tempCtrl,
                              hint: "37.2"),
                          _VitalField(
                              label: "Blood Pressure Systolic",
                              ctrl: _systolicCtrl,
                              hint: "120"),
                          _VitalField(
                              label: "Blood Pressure Diastolic",
                              ctrl: _diastolicCtrl,
                              hint: "80"),
                          _VitalField(
                              label: "Heart Rate (bpm)",
                              ctrl: _heartRateCtrl,
                              hint: "72"),
                          _VitalField(
                              label: "Respiratory Rate",
                              ctrl: _respRateCtrl,
                              hint: "16"),
                          _VitalField(
                              label: "Oxygen Saturation (%)",
                              ctrl: _o2Ctrl,
                              hint: "98"),
                          _VitalField(
                              label: "Weight (kg)",
                              ctrl: _weightCtrl,
                              hint: "70"),
                          _VitalField(
                              label: "Height (cm)",
                              ctrl: _heightCtrl,
                              hint: "175"),

                          context.verticalSpace(24),

                          isLoading
                              ? const Center(
                                  child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    CustomButton(
                                      text: "Save Vitals & Finish",
                                      backgroundColor: AppColors.primary,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        if (_recordId == null) {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.doctorHome,
                                            (route) => false,
                                          );
                                          return;
                                        }
                                        context
                                            .read<DoctorMedicalRecordCubit>()
                                            .addVitals(
                                              _recordId!,
                                              AddVitalsRequest(
                                                temperature: double.tryParse(
                                                    _tempCtrl.text),
                                                bloodPressureSystolic:
                                                    int.tryParse(
                                                        _systolicCtrl.text),
                                                bloodPressureDiastolic:
                                                    int.tryParse(
                                                        _diastolicCtrl.text),
                                                heartRate: int.tryParse(
                                                    _heartRateCtrl.text),
                                                respiratoryRate: int.tryParse(
                                                    _respRateCtrl.text),
                                                oxygenSaturation:
                                                    double.tryParse(
                                                        _o2Ctrl.text),
                                                weight: double.tryParse(
                                                    _weightCtrl.text),
                                                height: double.tryParse(
                                                    _heightCtrl.text),
                                                recordedBy: _doctorName,
                                              ),
                                            );
                                      },
                                    ),
                                    context.verticalSpace(12),
                                    CustomButton(
                                      text: "Skip & Finish",
                                      outlined: true,
                                      textColor: AppColors.primary,
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.doctorHome,
                                          (route) => false,
                                        );
                                      },
                                    ),
                                  ],
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
}

class _VitalField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;

  const _VitalField({
    required this.label,
    required this.ctrl,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  AppTextStyles.semiBold16Black.copyWith(fontSize: 13)),
          const SizedBox(height: 6),
          CustomTextFormField(
            hintText: hint,
            controller: ctrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }
}
