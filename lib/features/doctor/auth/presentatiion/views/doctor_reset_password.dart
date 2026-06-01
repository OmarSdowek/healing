// This screen is shown after forgot password — user enters the reset token
// received via email. We reuse DoctorSetNewPassword for the actual reset.
// This screen just navigates to set new password.
import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../../core/route/routes.dart';

class DoctorResetPassword extends StatelessWidget {
  const DoctorResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomHeader(title: 'Reset Password'),
              context.verticalSpace(30),

              Center(
                child: Image.asset(AssetsManger.authLogo, height: 150),
              ),
              context.verticalSpace(20),

              Text('Check Your Email', style: AppTextStyles.semiBold24dark),
              context.verticalSpace(10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'We sent a password reset link to your email.\nOpen it and copy the reset token, then press Continue.',
                  style: AppTextStyles.semiBold16Black,
                  textAlign: TextAlign.center,
                ),
              ),
              context.verticalSpace(40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: 'Continue',
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.doctorSetNewPassword);
                  },
                ),
              ),
              context.verticalSpace(15),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Back to Login',
                  style: AppTextStyles.semiBold16Black
                      .copyWith(color: AppColors.primary),
                ),
              ),
              context.verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
