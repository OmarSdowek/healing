import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/api_endpoint.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/context_extensions.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../data/models/doctor_register_request.dart';
import '../cubit/doctor_auth_cubit.dart';

// ─── SuperAdmin credentials (seeded) ─────────────────────────────────────────
const _adminEmail = 'admin@hospital.com';
const _adminPassword = 'P@ssw0rd!';

// ─── Departments (seeded) ─────────────────────────────────────────────────────
const _departments = [
  {'id': 1, 'name': 'Cardiology'},
  {'id': 2, 'name': 'Pediatrics'},
  {'id': 3, 'name': 'Orthopedics'},
  {'id': 4, 'name': 'Neurology'},
  {'id': 5, 'name': 'Emergency'},
  {'id': 6, 'name': 'Dermatology'},
  {'id': 7, 'name': 'Oncology'},
  {'id': 8, 'name': 'Psychiatry'},
  {'id': 9, 'name': 'Ophthalmology'},
  {'id': 10, 'name': 'ENT'},
  {'id': 11, 'name': 'Gynecology'},
  {'id': 12, 'name': 'Dentistry'},
  {'id': 13, 'name': 'Urology'},
  {'id': 14, 'name': 'Internal Medicine'},
  {'id': 15, 'name': 'General Surgery'},
];

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({super.key});

  @override
  State<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final nameController           = TextEditingController();
  final emailController          = TextEditingController();
  final nationalIdController     = TextEditingController();
  final phoneController          = TextEditingController();
  final licenseController        = TextEditingController();
  final specializationController = TextEditingController();
  final yearsController          = TextEditingController();
  final feeController            = TextEditingController();
  final bioController            = TextEditingController();
  final passwordController       = TextEditingController();
  final confirmPasswordController= TextEditingController();

  DateTime? selectedBirthday;
  String?   selectedGender;
  int?      selectedDepartmentId;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    nationalIdController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    specializationController.dispose();
    yearsController.dispose();
    feeController.dispose();
    bioController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Background flow ───────────────────────────────────────────────────────
  // 1. Login as SuperAdmin  →  get admin token
  // 2. POST /api/doctors    →  create doctor profile, get doctorId
  // 3. POST /api/auth/register  →  create login account using doctorId
  Future<void> _register(BuildContext context) async {
    // Validation
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        nationalIdController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        licenseController.text.trim().isEmpty ||
        specializationController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        selectedBirthday == null ||
        selectedGender == null ||
        selectedDepartmentId == null) {
      AppSnackBar.showWarning(context, 'Please fill in all required fields.');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      AppSnackBar.showWarning(context, 'Passwords do not match.');
      return;
    }

    // Show loading via cubit
    context.read<DoctorAuthCubit>();

    try {
      final api = ApiService();

      // ── Step 1: Admin login ───────────────────────────────────────────
      final loginRes = await api.post(
        ApiEndpoints.login,
        data: {'email': _adminEmail, 'password': _adminPassword},
      );
      final adminToken = loginRes.data['accessToken'] as String? ?? '';
      if (adminToken.isEmpty) {
        if (context.mounted) {
          AppSnackBar.showError(context, 'Admin authentication failed.');
        }
        return;
      }

      // ── Step 2: Create doctor profile ─────────────────────────────────
      final nameParts = nameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName  = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      final dob =
          '${selectedBirthday!.year}-${selectedBirthday!.month.toString().padLeft(2, '0')}-${selectedBirthday!.day.toString().padLeft(2, '0')}';

      final createRes = await Dio().post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.doctors}',
        data: {
          'firstName':        firstName,
          'lastName':         lastName,
          'dateOfBirth':      dob,
          'gender':           selectedGender,
          'nationalId':       nationalIdController.text.trim(),
          'licenseNumber':    licenseController.text.trim(),
          'email':            emailController.text.trim(),
          'phone':            phoneController.text.trim(),
          'specialization':   specializationController.text.trim(),
          'departmentId':     selectedDepartmentId,
          'yearsOfExperience':int.tryParse(yearsController.text.trim()) ?? 0,
          'consultationFee':  double.tryParse(feeController.text.trim()) ?? 0.0,
          'bio':              bioController.text.trim(),
        },
        options: Options(headers: {
          'Content-Type':            'application/json',
          'Authorization':           'Bearer $adminToken',
          'ngrok-skip-browser-warning': 'true',
        }),
      );

      final doctorId = (createRes.data['id'] as num?)?.toInt() ??
          (createRes.data['doctorId'] as num?)?.toInt();

      if (doctorId == null) {
        if (context.mounted) {
          AppSnackBar.showError(
              context, 'Failed to create doctor profile. Try again.');
        }
        return;
      }

      // ── Step 3: Register doctor account ──────────────────────────────
      if (context.mounted) {
        context.read<DoctorAuthCubit>().register(
              DoctorRegisterRequest(
                firstName: firstName,
                lastName:  lastName,
                email:     emailController.text.trim(),
                password:  passwordController.text,
                doctorId:  doctorId,
              ),
            );
      }
    } on DioException catch (e) {
      if (context.mounted) {
        final msg = e.response?.data?['detail'] ??
            e.response?.data?['title'] ??
            e.message ??
            'Registration failed.';
        AppSnackBar.showError(context, msg.toString());
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, 'Unexpected error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DoctorAuthCubit>(),
      child: BlocListener<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorRegisterSuccess) {
            context.showSuccess(
                'Registration successful! Please verify your email.');
            Navigator.pushNamed(
              context,
              Routes.doctorVerifyEmail,
              arguments: {
                'token': state.emailVerificationToken,
                'email': state.email,
              },
            );
          } else if (state is DoctorAuthError) {
            context.showError(state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: null),
                  const SizedBox(height: 24),

                  // ── Logo ──────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AssetsManger.logo, height: 50,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Healing',
                          style: AppTextStyles.headline1
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Text('Sign up',
                        style: AppTextStyles.semiBold24dark
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 30),

                  // ── Full Name ─────────────────────────────────────────
                  Text('Full Name', style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                      hintText: 'Enter your full name',
                      controller: nameController),
                  const SizedBox(height: 20),

                  // ── Email ─────────────────────────────────────────────
                  Text('Email', style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                      hintText: 'Enter your email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),

                  // ── Date of Birth ─────────────────────────────────────
                  Text('Date of birth', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomButton(
                    text: selectedBirthday == null
                        ? 'Select your birthday'
                        : '${selectedBirthday!.day}/${selectedBirthday!.month}/${selectedBirthday!.year}',
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1985, 1, 1),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => selectedBirthday = picked);
                    },
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    textColor: AppColors.primaryDark,
                  ),
                  const SizedBox(height: 20),

                  // ── National ID ───────────────────────────────────────
                  Text('National ID', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                      hintText: 'Enter your National ID',
                      controller: nationalIdController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),

                  // ── Phone ─────────────────────────────────────────────
                  Text('Phone Number', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                      hintText: 'Enter your phone',
                      controller: phoneController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 20),

                  // ── License Number ────────────────────────────────────
                  Text('License Number', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                      hintText: 'e.g. LIC-EG-99999',
                      controller: licenseController),
                  const SizedBox(height: 20),

                  // ── Specialization ────────────────────────────────────
                  Text('Specialization', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                      hintText: 'e.g. Internal Medicine',
                      controller: specializationController),
                  const SizedBox(height: 20),

                  // ── Department ────────────────────────────────────────
                  Text('Department', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedDepartmentId,
                        hint: Text('Select department',
                            style: TextStyle(color: Colors.grey.shade400)),
                        isExpanded: true,
                        items: _departments
                            .map((d) => DropdownMenuItem<int>(
                                  value: d['id'] as int,
                                  child: Text(d['name'] as String),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedDepartmentId = val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Years of Experience ───────────────────────────────
                  Text('Years of Experience',
                      style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                      hintText: 'e.g. 10',
                      controller: yearsController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),

                  // ── Consultation Fee ──────────────────────────────────
                  Text('Consultation Fee',
                      style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                      hintText: 'e.g. 400',
                      controller: feeController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true)),
                  const SizedBox(height: 20),

                  // ── Gender ────────────────────────────────────────────
                  Text('Gender', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Male',
                          onPressed: () =>
                              setState(() => selectedGender = 'Male'),
                          backgroundColor: selectedGender == 'Male'
                              ? AppColors.primary
                              : AppColors.cardBackground,
                          textColor: selectedGender == 'Male'
                              ? Colors.white
                              : AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Female',
                          onPressed: () =>
                              setState(() => selectedGender = 'Female'),
                          backgroundColor: selectedGender == 'Female'
                              ? AppColors.primary
                              : AppColors.cardBackground,
                          textColor: selectedGender == 'Female'
                              ? Colors.white
                              : AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Bio ───────────────────────────────────────────────
                  Text('Bio (optional)', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                      hintText: 'Brief description about yourself',
                      controller: bioController),
                  const SizedBox(height: 20),

                  // ── Password ──────────────────────────────────────────
                  Text('Password', style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                      hintText: 'Enter password',
                      controller: passwordController,
                      isPassword: true),
                  const SizedBox(height: 20),

                  // ── Confirm Password ──────────────────────────────────
                  Text('Confirm Password',
                      style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                      hintText: 'Confirm password',
                      controller: confirmPasswordController,
                      isPassword: true),
                  const SizedBox(height: 30),

                  // ── Sign Up Button ────────────────────────────────────
                  BlocBuilder<DoctorAuthCubit, DoctorAuthState>(
                    builder: (context, state) {
                      if (state is DoctorAuthLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      return CustomButton(
                        text: 'Sign up',
                        backgroundColor: AppColors.primary,
                        onPressed: () => _register(context),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Login link ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: AppTextStyles.reg20black),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, Routes.doctorLogin),
                        child: Text('Login',
                            style: AppTextStyles.semiBold16Black.copyWith(
                              color: AppColors.primary,
                              fontSize: context.sp(20),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
