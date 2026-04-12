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

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({super.key});

  @override
  State<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final bloodController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ✅ الميلاد
  DateTime? selectedBirthday;

  // ✅ الجنس
  String? selectedGender;

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
              const CustomHeader(title: null),
              const SizedBox(height: 24),

              /// Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsManger.logo,
                    height: 50,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text("Healing", style: AppTextStyles.headline1.copyWith(color: AppColors.primary)),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: Text("Sign up", style: AppTextStyles.semiBold24dark.copyWith(fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 30),

              /// Full Name
              Text("Full Name", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(hintText: "Enter your full name", controller: nameController),

              const SizedBox(height: 20),

              /// Email
              Text("Email", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(hintText: "Enter your email", controller: emailController, keyboardType: TextInputType.emailAddress),

              const SizedBox(height: 20),

              /// Birthday (DatePicker)
              Text("Date of birth", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomButton(
                text: selectedBirthday == null
                    ? "Select your birthday"
                    : "${selectedBirthday!.day}/${selectedBirthday!.month}/${selectedBirthday!.year}",
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(1990, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => selectedBirthday = picked);
                  }
                },
                backgroundColor: AppColors.primary.withOpacity(0.1),
                textColor: AppColors.primaryDark,
              ),

              const SizedBox(height: 20),

              /// National ID
              Text("National ID", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(hintText: "Enter your ID", controller: idController, keyboardType: TextInputType.number),

              const SizedBox(height: 20),

              /// Phone Number
              Text("Phone Number", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(hintText: "Enter your phone", controller: phoneController, keyboardType: TextInputType.phone),

              const SizedBox(height: 20),

              /// Blood Type
              Text("Blood Type", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(hintText: "Enter your blood type", controller: bloodController),

              const SizedBox(height: 20),

              /// Gender (زرارين)
              Text("Gender", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Male",
                      onPressed: () => setState(() => selectedGender = "Male"),
                      backgroundColor: selectedGender == "Male" ? AppColors.primary : AppColors.cardBackground,
                      textColor: selectedGender == "Male" ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: "Female",
                      onPressed: () => setState(() => selectedGender = "Female"),
                      backgroundColor: selectedGender == "Female" ? AppColors.primary : AppColors.cardBackground,
                      textColor: selectedGender == "Female" ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Password
              Text("Password", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(hintText: "Enter your password", controller: passwordController, isPassword: true),

              const SizedBox(height: 20),

              /// Confirm Password
              Text("Confirm Password", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(10),
              CustomTextFormField(hintText: "Confirm your password", controller: confirmPasswordController, isPassword: true),

              const SizedBox(height: 30),

              /// Sign Up Button
              CustomButton(
                text: "Sign up",
                backgroundColor: AppColors.primary,
                onPressed: () {
                  print("Name: ${nameController.text}");
                  print("Email: ${emailController.text}");
                  print("Birthday: $selectedBirthday");
                  print("Gender: $selectedGender");
                  print("ID: ${idController.text}");
                  print("Phone: ${phoneController.text}");
                  print("Blood: ${bloodController.text}");
                  print("Password: ${passwordController.text}");
                  Navigator.pushNamed(context, Routes.doctorVerifyEmail);
                },
              ),

              const SizedBox(height: 20),

              /// Already have account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: AppTextStyles.reg20black),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, Routes.doctorLogin),
                    child: Text("Login", style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.primary, fontSize: context.sp(20))),
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
