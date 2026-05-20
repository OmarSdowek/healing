import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:healing/features/doctor/profile/presentation/cubit/doctor_profile_cubit.dart';
import 'package:healing/features/doctor/profile/presentation/cubit/doctor_profile_cubit_factory.dart';

class DoctorPersonalInformation extends StatefulWidget {
  const DoctorPersonalInformation({super.key});

  @override
  State<DoctorPersonalInformation> createState() =>
      _DoctorPersonalInformationState();
}

class _DoctorPersonalInformationState
    extends State<DoctorPersonalInformation> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _specializationCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();


  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _specializationCtrl.dispose();
    _bioCtrl.dispose();
    _yearsCtrl.dispose();
    _licenseCtrl.dispose();
    super.dispose();
  }

  void _fillForm(DoctorProfileEntity p) {
    print('NAME => ${p.fullName}');
    print('EMAIL => ${p.email}');
    print('PHONE => ${p.phone}');
    print('SPEC => ${p.specialization}');
    print('BIO => ${p.bio}');
    print('YEARS => ${p.yearsOfExperience}');
    print('LICENSE => ${p.licenseNumber}');

    _nameCtrl.text = p.fullName ?? '';
    _emailCtrl.text = p.email ?? '';
    _phoneCtrl.text = p.phone ?? '';
    _specializationCtrl.text = p.specialization ?? '';
    _bioCtrl.text = p.bio ?? '';
    _yearsCtrl.text = p.yearsOfExperience?.toString() ?? '';
    _licenseCtrl.text = p.licenseNumber ?? '';
  }

  void _save(BuildContext context) {
    context.read<DoctorProfileCubit>().updateProfile(
          DoctorProfileEntity(
            fullName: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            specialization: _specializationCtrl.text.trim(),
            bio: _bioCtrl.text.trim(),
            yearsOfExperience: int.tryParse(_yearsCtrl.text.trim()),
            licenseNumber: _licenseCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorProfileCubitFactory.create()..getProfile(),
      child: BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
        listener: (context, state) {
          if (state is DoctorProfileUpdateSuccess) {
            AppSnackBar.showSuccess(context, 'Profile updated successfully');
            Navigator.pop(context);
          } else if (state is DoctorProfileError) {
            AppSnackBar.showError(context, state.message);
          }
          if (state is DoctorProfileLoaded) {
            print(state.profile);
            _fillForm(state.profile);
          }
        },
        builder: (context, state) {
          // Fill controllers as soon as data arrives
          if (state is DoctorProfileLoaded) {
            _fillForm(state.profile);
          }

          if (state is DoctorProfileLoading) {
            return const Scaffold(
              backgroundColor: Color(0xFFF4F6FB),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FB),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(title: 'Personal Information'),
                    context.verticalSpace(24),

                    // ── Avatar ────────────────────────────────────────
                    Center(
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: Icon(Icons.person,
                            size: 48, color: AppColors.primary),
                      ),
                    ),
                    context.verticalSpace(24),

                    _Field(
                      label: 'Full Name',
                      controller: _nameCtrl,
                      icon: Icons.person_outline,
                    ),
                    context.verticalSpace(14),

                    _Field(
                      label: 'Email',
                      controller: _emailCtrl,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    context.verticalSpace(14),

                    _Field(
                      label: 'Phone Number',
                      controller: _phoneCtrl,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    context.verticalSpace(14),

                    _Field(
                      label: 'Specialization',
                      controller: _specializationCtrl,
                      icon: Icons.medical_services_outlined,
                    ),
                    context.verticalSpace(14),

                    _Field(
                      label: 'Years of Experience',
                      controller: _yearsCtrl,
                      icon: Icons.workspace_premium_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    context.verticalSpace(14),

                    _Field(
                      label: 'License Number',
                      controller: _licenseCtrl,
                      icon: Icons.badge_outlined,
                    ),
                    context.verticalSpace(14),

                    _Field(
                      label: 'Bio',
                      controller: _bioCtrl,
                      icon: Icons.info_outline,
                      maxLines: 3,
                    ),
                    context.verticalSpace(32),

                    // ── Save Button ───────────────────────────────────
                    Builder(
                      builder: (ctx) {
                        final saving =
                            context.watch<DoctorProfileCubit>().state
                                is DoctorProfileUpdating;
                        return CustomButton(
                          text: saving ? 'Saving...' : 'Save Changes',
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                          onPressed:
                              saving ? () {} : () => _save(context),
                        );
                      },
                    ),
                    context.verticalSpace(20),
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

// ─── Reusable field widget ────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.semiBold16Black),
        context.verticalSpace(6),
        CustomTextFormField(
          hintText: label,
          controller: controller,
          keyboardType: keyboardType,
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        ),
      ],
    );
  }
}
