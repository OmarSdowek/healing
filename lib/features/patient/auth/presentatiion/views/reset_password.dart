import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/route/routes.dart';

class PatientResetPassword extends StatelessWidget {
  PatientResetPassword({super.key});

  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔹 Header
              const CustomHeader(title: "Reset Password"),

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
              Text(
                "Verify Code",
                style: AppTextStyles.semiBold24dark,
              ),

              context.verticalSpace(10),

              /// 🔹 Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "We send a code to example@gmail.com",
                  style: AppTextStyles.semiBold16Black,
                  textAlign: TextAlign.center,
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 PIN CODE (UPDATED)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MaterialPinField(
                  length: 6,
                  onCompleted: (pin) => print('PIN: $pin'),
                  onChanged: (value) => print('Changed: $value'),
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.outlined,
                    cellSize: Size(56, 64),
                    borderRadius: BorderRadius.circular(4),
                    fillColor: AppColors.otp,
                  ),
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 Confirm Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: "Confirm",
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.setNewPassword);
                  },
                ),
              ),

              context.verticalSpace(15),

              /// 🔹 Resend Code
              TextButton(
                onPressed: () {},
                child: Text(
                  "Resend Code",
                  style: AppTextStyles.semiBold16Black.copyWith(
                    color: AppColors.primary,
                  ),
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