import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../../auth/presentatiion/cubit/doctor_auth_cubit.dart';
import '../../../auth/presentatiion/cubit/doctor_auth_cubit_factory.dart';

class DoctorManagePasswordScreen extends StatefulWidget {
  const DoctorManagePasswordScreen({super.key});

  @override
  State<DoctorManagePasswordScreen> createState() =>
      _DoctorManagePasswordScreenState();
}

class _DoctorManagePasswordScreenState
    extends State<DoctorManagePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorAuthCubitFactory.create(),
      child: BlocConsumer<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorPasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password changed successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is DoctorAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DoctorAuthLoading;

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(title: "Manage Password"),
                    context.verticalSpace(20),

                    Text("Current Password",
                        style: AppTextStyles.semiBold16Black),
                    context.verticalSpace(6),
                    CustomTextFormField(
                      hintText: "Enter current password",
                      controller: _currentCtrl,
                      isPassword: true,
                    ),

                    context.verticalSpace(16),

                    Text("New Password",
                        style: AppTextStyles.semiBold16Black),
                    context.verticalSpace(6),
                    CustomTextFormField(
                      hintText: "Enter new password",
                      controller: _newCtrl,
                      isPassword: true,
                    ),

                    context.verticalSpace(16),

                    Text("Confirm New Password",
                        style: AppTextStyles.semiBold16Black),
                    context.verticalSpace(6),
                    CustomTextFormField(
                      hintText: "Confirm new password",
                      controller: _confirmCtrl,
                      isPassword: true,
                    ),

                    const Spacer(),

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: "Change Password",
                            onPressed: () {
                              if (_newCtrl.text != _confirmCtrl.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "New passwords don't match"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (_newCtrl.text.length < 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Password must be at least 8 characters"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              // Use forgot password flow with new password
                              context.read<DoctorAuthCubit>().changePassword(
                                    currentPassword: _currentCtrl.text,
                                    newPassword: _newCtrl.text,
                                  );
                            },
                            height: 48,
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                          ),
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
