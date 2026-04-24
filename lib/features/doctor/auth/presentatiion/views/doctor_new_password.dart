import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/alart_dailog.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit_factory.dart';

class DoctorSetNewPassword extends StatefulWidget {
  /// The OTP token received from the reset-password step
  final String? resetToken;
  const DoctorSetNewPassword({super.key, this.resetToken});

  @override
  State<DoctorSetNewPassword> createState() => _DoctorSetNewPasswordState();
}

class _DoctorSetNewPasswordState extends State<DoctorSetNewPassword> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorAuthCubitFactory.create(),
      child: BlocListener<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorPasswordResetSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessDialog(
                title: 'Password Changed',
                subtitle: 'You can log in with your new password',
                onConfirm: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.doctorLogin);
                },
              ),
            );
          }
          if (state is DoctorAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: "Set New Password"),
                  context.verticalSpace(30),
                  Center(
                    child: Image.asset(
                      AssetsManger.authLogo,
                      height: context.h(150),
                    ),
                  ),
                  context.verticalSpace(25),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(30)),
                      child: Text(
                        "Please create a new password for your Account",
                        style: AppTextStyles.semiBold16Black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  context.verticalSpace(30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Password",
                          style: AppTextStyles.semiBold16Black,
                        ),
                        context.verticalSpace(8),
                        CustomTextFormField(
                          hintText: "Enter new password",
                          controller: _newPasswordController,
                          isPassword: true,
                        ),
                        context.verticalSpace(25),
                        Text(
                          "Confirm Password",
                          style: AppTextStyles.semiBold16Black,
                        ),
                        context.verticalSpace(8),
                        CustomTextFormField(
                          hintText: "Confirm new password",
                          controller: _confirmPasswordController,
                          isPassword: true,
                        ),
                      ],
                    ),
                  ),
                  context.verticalSpace(30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                    child: BlocBuilder<DoctorAuthCubit, DoctorAuthState>(
                      builder: (context, state) {
                        if (state is DoctorAuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CustomButton(
                          text: "Reset Password",
                          backgroundColor: AppColors.primary,
                          onPressed: () {
                            if (_newPasswordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<DoctorAuthCubit>().resetPassword(
                              token: widget.resetToken ?? "",
                              newPassword: _newPasswordController.text,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  context.verticalSpace(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
