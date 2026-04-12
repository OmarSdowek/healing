import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../../../../core/route/routes.dart';

class DoctorVerifyPassword extends StatefulWidget {
  DoctorVerifyPassword({super.key});

  @override
  State<DoctorVerifyPassword> createState() => _DoctorVerifyPasswordState();
}

class _DoctorVerifyPasswordState extends State<DoctorVerifyPassword> {
  late TextEditingController emailController ;


  @override
  void initState() {
    emailController = TextEditingController();
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
              const CustomHeader(title: "Verify email address"),

              context.verticalSpace(30),

              /// 🔹 Logo
              Center(
                child: Image.asset(
                  AssetsManger.authLogo,
                  height: 150,
                  width: 150,
                ),
              ),

              context.verticalSpace(20),

              /// 🔹 Title
              Center(
                child: Text(
                  "Check Email",
                  style: AppTextStyles.semiBold24dark,
                ),
              ),

              context.verticalSpace(10),

              /// 🔹 Subtitle
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Enter your email to verify your account",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    /// Send Link
                    CustomButton(
                      text: "Send Link",
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.verifyCode);
                      },
                    ),

                    context.verticalSpace(12),

                    /// Back to Login
                    CustomButton(
                      text: "Back to Login",
                      outlined: true,
                      backgroundColor: AppColors.white,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.doctorLogin);
                      },
                    ),
                  ],
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