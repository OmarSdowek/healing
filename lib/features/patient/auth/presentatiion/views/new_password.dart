import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_button.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/widgets/alart_dailog.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../manger/patient_auth_cubit.dart';

class PatientSetNewPassword extends StatefulWidget {
  PatientSetNewPassword({super.key});

  @override
  State<PatientSetNewPassword> createState() => _PatientSetNewPasswordState();
}

class _PatientSetNewPasswordState extends State<PatientSetNewPassword> {
   late TextEditingController newPasswordController ;

  late TextEditingController confirmPasswordController;


  @override
  void initState() {
    newPasswordController  = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 Header
              const CustomHeader(title: "Set New Password"),

              context.verticalSpace(30),

              /// 🔹 Logo
              Center(
                child: Image.asset(
                  AssetsManger.authLogo,
                  height: 150,
                ),
              ),

              context.verticalSpace(25),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Please create a new password for your\n Account",
                    style: AppTextStyles.semiBold16Black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 Password Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// New Password
                    Text(
                      "New Password",
                      style: AppTextStyles.semiBold16Black,
                    ),
                    context.verticalSpace(8),

                    CustomTextFormField(
                      hintText: "Enter new password",
                      controller: newPasswordController,
                      isPassword: true,
                    ),

                    context.verticalSpace(25),

                    /// Confirm Password
                    Text(
                      "Confirm Password in your Email",
                      style: AppTextStyles.semiBold16Black,
                    ),
                    context.verticalSpace(8),

                    CustomTextFormField(
                      hintText: "Confirm new password",
                      controller: confirmPasswordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 Button
              BlocConsumer<PatientAuthCubit, PatientAuthState>(
                listener: (context, state) {
                  if (state is PatientPasswordResetSuccess) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => SuccessDialog(
                        title: 'Password Changed',
                        subtitle: 'You can log in with your new password',
                        onConfirm: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.patientLogin,
                          );
                        },
                      ),
                    );
                  }

                  if (state is PatientAuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },

                builder: (context, state) {
                  if (state is PatientAuthLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text:  "Reset Password",
                      backgroundColor: AppColors.primary,
                      onPressed:() {
                        final newPassword = newPasswordController.text;
                        final confirmPassword = confirmPasswordController.text;

                        if (newPassword.isEmpty || confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter all fields")),
                          );
                          return;
                        }


                        context.read<PatientAuthCubit>().resetPassword(
                          token: confirmPassword,
                          newPassword: newPassword,
                        );
                      },
                    ),
                  );
                },
              ),

              context.verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}