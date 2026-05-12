import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:healing/features/doctor/profile/presentation/cubit/doctor_profile_cubit.dart';
import 'package:healing/features/doctor/profile/presentation/cubit/doctor_profile_cubit_factory.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';

class DoctorPersonalInformation extends StatefulWidget {
  const DoctorPersonalInformation({super.key});

  @override
  State<DoctorPersonalInformation> createState() =>
      _DoctorPersonalInformationState();
}

class _DoctorPersonalInformationState extends State<DoctorPersonalInformation> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController specializationController;
  late TextEditingController bioController;
  late TextEditingController yearsController;
  late TextEditingController licenseController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    specializationController = TextEditingController();
    bioController = TextEditingController();
    yearsController = TextEditingController();
    licenseController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    specializationController.dispose();
    bioController.dispose();
    yearsController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  void _loadProfileData(DoctorProfileEntity profile) {
    nameController.text = profile.fullName ?? '';
    emailController.text = profile.email ?? '';
    phoneController.text = profile.phone ?? '';
    specializationController.text = profile.specialization ?? '';
    bioController.text = profile.bio ?? '';
    yearsController.text = profile.yearsOfExperience?.toString() ?? '';
    licenseController.text = profile.licenseNumber ?? '';
  }

  void _saveProfile(BuildContext context) {
    final updatedProfile = DoctorProfileEntity(
      fullName: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      specialization: specializationController.text,
      bio: bioController.text,
      yearsOfExperience: int.tryParse(yearsController.text),
      licenseNumber: licenseController.text,
    );

    context.read<DoctorProfileCubit>().updateProfile(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = DoctorProfileCubitFactory.create();
        cubit.getProfile(); // Load profile when cubit is created
        return cubit;
      },
      child: BlocListener<DoctorProfileCubit, DoctorProfileState>(
        listener: (context, state) {
          if (state is DoctorProfileLoaded) {
            _loadProfileData(state.profile);
          } else if (state is DoctorProfileUpdateSuccess) {
            AppSnackBar.showSuccess(context, 'Profile updated successfully.');
            Navigator.pop(context);
          } else if (state is DoctorProfileError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
              builder: (context, state) {
                if (state is DoctorProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      const CustomHeader(title: "Personal Information"),

                      context.verticalSpace(20),

                      /// Name
                      _buildTextField(
                        label: "Full Name",
                        controller: nameController,
                        hint: "Enter your full name",
                      ),

                      context.verticalSpace(16),

                      /// Email
                      _buildTextField(
                        label: "Email",
                        controller: emailController,
                        hint: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                      ),

                      context.verticalSpace(16),

                      /// Phone
                      _buildTextField(
                        label: "Phone Number",
                        controller: phoneController,
                        hint: "Enter your phone number",
                        keyboardType: TextInputType.phone,
                      ),

                      context.verticalSpace(16),

                      /// Specialization
                      _buildTextField(
                        label: "Specialization",
                        controller: specializationController,
                        hint: "Enter your specialization",
                      ),

                      context.verticalSpace(16),

                      /// Bio
                      _buildTextField(
                        label: "Bio",
                        controller: bioController,
                        hint: "Enter your bio",
                        maxLines: 3,
                      ),

                      context.verticalSpace(16),

                      /// Years of Experience
                      _buildTextField(
                        label: "Years of Experience",
                        controller: yearsController,
                        hint: "Enter years of experience",
                        keyboardType: TextInputType.number,
                      ),

                      context.verticalSpace(16),

                      /// License Number
                      _buildTextField(
                        label: "License Number",
                        controller: licenseController,
                        hint: "Enter your license number",
                      ),

                      context.verticalSpace(30),

                      /// Save Button
                      BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
                        builder: (context, state) {
                          final isUpdating = state is DoctorProfileUpdating;
                          return CustomButton(
                            text: isUpdating ? "Saving..." : "Save Changes",
                            backgroundColor: AppColors.primary,
                            onPressed: isUpdating
                                ? () {}
                                : () => _saveProfile(context),
                          );
                        },
                      ),

                      context.verticalSpace(16),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.black),
        ),
        context.verticalSpace(8),
        CustomTextFormField(
          hintText: hint,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
