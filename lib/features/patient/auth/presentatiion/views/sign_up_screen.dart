import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';

import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_text_feild.dart';

class PatientSignUpScreen extends StatefulWidget {
  PatientSignUpScreen({super.key});

  @override
  State<PatientSignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<PatientSignUpScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController bloodController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header
              const CustomHeader(title: null),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsManger.logo,
                    height: 50,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Healing",
                    style: AppTextStyles.headline1.copyWith(color: AppColors.primary),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 Title
              Center(
                child: Text(
                  "Sign up",
                  style: AppTextStyles.semiBold24dark.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// 🔹 Full Name
              Text("Full Name", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),

              CustomTextFormField(
                hintText: "Enter your full name",
                controller: nameController,
              ),

              const SizedBox(height: 20),

              /// 🔹 Email
              Text("Email", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(
                hintText: "Enter your email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              context.verticalSpace(10),

              Text("Date of birth", style: AppTextStyles.semiBold16Black),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(hintText: "Day", controller: TextEditingController())),
                  const SizedBox(width: 8),
                  Expanded(child: CustomTextFormField(hintText: "Month", controller: TextEditingController())),
                  const SizedBox(width: 8),
                  Expanded(child: CustomTextFormField(hintText: "Year", controller: TextEditingController())),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 National ID
              Text("National ID", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(
                hintText: "Enter your ID",
                controller: idController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              /// 🔹 Phone Number
              Text("Phone Number", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),

              CustomTextFormField(
                hintText: "Enter your phone",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              /// 🔹 Blood Type
              Text("Blood Type", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(
                hintText: "Enter your blood type",
                controller: bloodController,
              ),

              const SizedBox(height: 20),

              /// 🔹 Gender
              Text("Gender", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Male",
                      onPressed: () {},
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: "Female",
                      outlined: true,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.primary,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 Password
              Text("Password", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),

              CustomTextFormField(
                hintText: "Enter your password",
                controller: passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 20),

              /// 🔹 Confirm Password
              Text("Confirm Password", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),

              CustomTextFormField(
                hintText: "Confirm your password",
                controller: confirmPasswordController,
                isPassword: true,
              ),

              const SizedBox(height: 30),

              /// 🔹 Sign Up Button
              CustomButton(
                text: "Sign up",
                backgroundColor: AppColors.primary,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.verifyEmail);
                },
              ),

              const SizedBox(height: 20),

              /// 🔹 Already have account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyles.reg20black,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.patientLogin);
                    },
                    child: Text(
                      "Login",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.primary,
                        fontSize: context.sp(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
