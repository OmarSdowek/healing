import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/alart_dailog.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../cubit/doctor_auth_cubit.dart';

class DoctorSetNewPassword extends StatefulWidget {
  const DoctorSetNewPassword({super.key});

  @override
  State<DoctorSetNewPassword> createState() => _DoctorSetNewPasswordState();
}

class _DoctorSetNewPasswordState extends State<DoctorSetNewPassword> {
  final _tokenCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DoctorAuthCubit>(),
      child: BlocConsumer<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorPasswordResetSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessDialog(
                title: 'Password Changed',
                subtitle: 'You can now log in with your new password.',
                onConfirm: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.doctorLogin);
                },
              ),
            );
          } else if (state is DoctorAuthError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is DoctorAuthLoading;
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(title: 'Set New Password'),
                    context.verticalSpace(30),

                    Center(
                      child:
                          Image.asset(AssetsManger.authLogo, height: 150),
                    ),
                    context.verticalSpace(25),

                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Enter the reset token from your email\nand choose a new password.',
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
                          // ── Reset Token ───────────────────────────────
                          Text('Reset Token',
                              style: AppTextStyles.semiBold16Black),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: 'Paste the token from your email',
                            controller: _tokenCtrl,
                          ),
                          context.verticalSpace(20),

                          // ── New Password ──────────────────────────────
                          Text('New Password',
                              style: AppTextStyles.semiBold16Black),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: 'Enter new password',
                            controller: _newPasswordCtrl,
                            isPassword: true,
                          ),
                          context.verticalSpace(20),

                          // ── Confirm Password ──────────────────────────
                          Text('Confirm Password',
                              style: AppTextStyles.semiBold16Black),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: 'Confirm new password',
                            controller: _confirmPasswordCtrl,
                            isPassword: true,
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
                              text: 'Reset Password',
                              backgroundColor: AppColors.primary,
                              onPressed: () {
                                final token = _tokenCtrl.text.trim();
                                final newPw = _newPasswordCtrl.text;
                                final confirmPw =
                                    _confirmPasswordCtrl.text;

                                if (token.isEmpty ||
                                    newPw.isEmpty ||
                                    confirmPw.isEmpty) {
                                  AppSnackBar.showWarning(
                                      context, 'Please fill in all fields.');
                                  return;
                                }
                                if (newPw != confirmPw) {
                                  AppSnackBar.showWarning(
                                      context, 'Passwords do not match.');
                                  return;
                                }
                                context
                                    .read<DoctorAuthCubit>()
                                    .resetPassword(
                                      token: token,
                                      newPassword: newPw,
                                    );
                              },
                            ),
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
