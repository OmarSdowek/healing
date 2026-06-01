import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../cubit/doctor_auth_cubit.dart';

class DoctorForgotPassword extends StatefulWidget {
  const DoctorForgotPassword({super.key});

  @override
  State<DoctorForgotPassword> createState() => _DoctorForgotPasswordState();
}

class _DoctorForgotPasswordState extends State<DoctorForgotPassword> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DoctorAuthCubit>(),
      child: BlocListener<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorForgotPasswordSent) {
            AppSnackBar.showSuccess(
                context, 'Reset link sent! Please check your email.');
            Navigator.pushNamed(context, Routes.doctorSetNewPassword);
          } else if (state is DoctorAuthError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: BlocBuilder<DoctorAuthCubit, DoctorAuthState>(
              builder: (context, state) {
                final isLoading = state is DoctorAuthLoading;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeader(title: 'Forgot Password'),
                      context.verticalSpace(30),

                      Center(
                        child:
                            Image.asset(AssetsManger.authLogo, height: 150),
                      ),
                      context.verticalSpace(20),

                      Center(
                        child: Text('Forgot Password',
                            style: AppTextStyles.semiBold24dark),
                      ),
                      context.verticalSpace(10),
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Enter your email and we\'ll send you a reset link.',
                            style: AppTextStyles.semiBold16Black,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      context.verticalSpace(30),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email',
                                style: AppTextStyles.semiBold16Black),
                            context.verticalSpace(8),
                            CustomTextFormField(
                              hintText: 'Enter your email',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                      context.verticalSpace(30),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator())
                            : CustomButton(
                                text: 'Send Reset Link',
                                backgroundColor: AppColors.primary,
                                onPressed: () {
                                  final email = _emailCtrl.text.trim();
                                  if (email.isEmpty) {
                                    AppSnackBar.showWarning(context,
                                        'Please enter your email.');
                                    return;
                                  }
                                  context
                                      .read<DoctorAuthCubit>()
                                      .forgotPassword(email);
                                },
                              ),
                      ),
                      context.verticalSpace(20),
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
}
