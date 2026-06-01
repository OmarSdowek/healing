import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/context_extensions.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../data/models/doctor_register_request.dart';
import '../cubit/doctor_auth_cubit.dart';

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({super.key});

  @override
  State<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final doctorIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    doctorIdController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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

                  /// LOGO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsManger.logo,
                        height: 50,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Healing',
                        style: AppTextStyles.headline1
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      'Sign up',
                      style: AppTextStyles.semiBold24dark
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Subtitle
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Use the Doctor ID and email sent to you by the hospital admin.',
                        style: AppTextStyles.semiBold16Black
                            .copyWith(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Full Name
                  Text('Full Name', style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                    hintText: 'Enter your full name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),

                  /// Email
                  Text('Email', style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                    hintText: 'Enter your email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  /// Doctor ID
                  Text('Doctor ID', style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(4),
                  Text(
                    'The ID sent to your email by the hospital admin',
                    style: AppTextStyles.semiBold16Black
                        .copyWith(fontSize: 12, color: Colors.grey),
                  ),
                  context.verticalSpace(10),
                  CustomTextFormField(
                    hintText: 'e.g. 16',
                    controller: doctorIdController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  /// Password
                  Text('Password', style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                    hintText: 'Enter password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),

                  /// Confirm Password
                  Text('Confirm Password', style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                    hintText: 'Confirm password',
                    controller: confirmPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),

                  /// Sign Up Button
                  BlocBuilder<DoctorAuthCubit, DoctorAuthState>(
                    builder: (context, state) {
                      if (state is DoctorAuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CustomButton(
                        text: 'Sign up',
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          if (nameController.text.trim().isEmpty ||
                              emailController.text.trim().isEmpty ||
                              doctorIdController.text.trim().isEmpty ||
                              passwordController.text.isEmpty) {
                            AppSnackBar.showWarning(
                                context, 'Please fill in all required fields.');
                            return;
                          }

                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            AppSnackBar.showWarning(
                                context, 'Passwords do not match.');
                            return;
                          }

                          final doctorId =
                              int.tryParse(doctorIdController.text.trim());
                          if (doctorId == null) {
                            AppSnackBar.showWarning(
                                context, 'Doctor ID must be a number.');
                            return;
                          }

                          final nameParts =
                              nameController.text.trim().split(' ');
                          final firstName = nameParts.first;
                          final lastName = nameParts.length > 1
                              ? nameParts.sublist(1).join(' ')
                              : '';

                          context.read<DoctorAuthCubit>().register(
                                DoctorRegisterRequest(
                                  firstName: firstName,
                                  lastName: lastName,
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                  doctorId: doctorId,
                                ),
                              );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  /// Already have account? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: AppTextStyles.reg20black),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.doctorLogin),
                        child: Text(
                          'Login',
                          style: AppTextStyles.semiBold16Black.copyWith(
                            color: AppColors.primary,
                            fontSize: context.sp(20),
                          ),
                        ),
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
