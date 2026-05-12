import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/helper/extentions/context_extensions.dart';
import 'package:healing/core/widgets/custom_button.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../../../../core/route/routes.dart';
import '../manger/patient_auth_cubit.dart';

class PatientForgotPassword extends StatefulWidget {
  PatientForgotPassword({super.key});

  @override
  State<PatientForgotPassword> createState() => _PatientForgotPasswordState();
}

class _PatientForgotPasswordState extends State<PatientForgotPassword> {
  late TextEditingController emailController ;
@override
  void initState() {
    emailController =  TextEditingController();
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
              const CustomHeader(title: "Forgot your Password"),

              context.verticalSpace(30),

              /// 🔹 Logo
              Center(
                child: Image.asset(
                  AssetsManger.authLogo,
                  height: 150,
                ),
              ),

              context.verticalSpace(20),

              /// 🔹 Title
              Center(
                child: Text(
                  "Forgot Password",
                  style: AppTextStyles.semiBold24dark,
                ),
              ),

              context.verticalSpace(10),

              /// 🔹 Subtitle
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "A Code will be sent to your email to help\n reset password",
                    style: AppTextStyles.semiBold16Black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 Email Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: AppTextStyles.semiBold16Black,
                    ),
                    context.verticalSpace(8),

                    CustomTextFormField(
                      hintText: "Enter your email",
                      controller: emailController,
                    ),
                  ],
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 Buttons
              ///
              BlocConsumer<PatientAuthCubit, PatientAuthState>(
                listener: (context, state) {
                  if (state is PatientForgotPasswordSent) {
                    context.showSuccess('Reset link sent! Please check your email.');
                    Navigator.pushNamed(context, Routes.setNewPassword);
                  }
                  if (state is PatientAuthError) {
                    context.showError(state.message);
                  }
                },
                builder: (context, state) {
                  if (state is PatientAuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Next",
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        final email = emailController.text.trim();
                        if (email.isEmpty) {
                          context.showWarning('Please enter your email address.');
                          return;
                        }
                        context.read<PatientAuthCubit>().forgotPassword(email);
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