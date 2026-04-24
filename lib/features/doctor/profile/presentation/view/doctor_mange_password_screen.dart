import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/alart_dailog.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit_factory.dart';
import '../../../../../core/route/routes.dart';

class DoctorManagePasswordScreen extends StatefulWidget {
  const DoctorManagePasswordScreen({super.key});

  @override
  State<DoctorManagePasswordScreen> createState() =>
      _DoctorManagePasswordScreenState();
}

class _DoctorManagePasswordScreenState
    extends State<DoctorManagePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
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
                subtitle: 'Your password has been updated successfully',
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
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(12),
                vertical: context.h(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: "Manage Password"),
                  context.verticalSpace(20),

                  Text(
                    "Current password",
                    style: AppTextStyles.semiBold16Black,
                  ),
                  context.verticalSpace(6),
                  CustomTextFormField(
                    hintText: "Enter your current password",
                    controller: _currentController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),

                  context.verticalSpace(16),

                  Text("New password", style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(6),
                  CustomTextFormField(
                    hintText: "Enter new password",
                    controller: _newController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),

                  context.verticalSpace(16),

                  Text(
                    "Confirm new password",
                    style: AppTextStyles.semiBold16Black,
                  ),
                  context.verticalSpace(6),
                  CustomTextFormField(
                    hintText: "Confirm new password",
                    controller: _confirmController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),

                  const Spacer(),

                  BlocBuilder<DoctorAuthCubit, DoctorAuthState>(
                    builder: (context, state) {
                      if (state is DoctorAuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return CustomButton(
                        text: "Change Password",
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_newController.text != _confirmController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Passwords do not match"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          // Uses reset-password endpoint with current as token
                          context.read<DoctorAuthCubit>().resetPassword(
                            token: _currentController.text,
                            newPassword: _newController.text,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
