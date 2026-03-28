import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';

class PatientSignIn extends StatelessWidget {
  PatientSignIn({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: null),

            /// 🔹 Logo + Healing
            const SizedBox(height: 40),
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
                  style: AppTextStyles.headline1.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            context.verticalSpace(20),

            /// 🔹 Title + Subtitle
            Text(
              "Login",
              style: AppTextStyles.semiBold24dark.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            context.verticalSpace(10),
            Text(
              "Enter your information to log in to your account",
              style: AppTextStyles.reg20black,
              textAlign: TextAlign.center,
            ),

            context.verticalSpace(20),

            /// 🔹 Input Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Name Label
                  Text(
                    "Name",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  context.verticalSpace(8),

                  CustomTextFormField(
                    hintText: "Enter your name",
                    controller: nameController,
                  ),

                  context.verticalSpace(20),

                  /// 🔹 Password Label
                  Text(
                    "Password",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  context.verticalSpace(8),

                  CustomTextFormField(
                    hintText: "Enter your password",
                    controller: passwordController,
                    isPassword: true,
                  ),
                ],
              ),
            ),

            /// 🔹 Forget Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.forgotPassword);
                  },
                  child: Text(
                    "Forget Password?",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ),

            /// 🔹 Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                text: "Login",

                onPressed: () {
                  // Handle Login
                },
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Social Login Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomButton(
                    text: "Log in with Google",
                    backgroundColor: Colors.white,
                    textColor: AppColors.primary,
                    outlined: false,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.patientHome);
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: "Log in with Facebook",
                    backgroundColor: Colors.white,
                    textColor: AppColors.primary,
                    outlined: false,
                    onPressed: () {
                      // Facebook Login
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 🔹 Sign up link
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't have any account? ",
                    style: AppTextStyles.reg20black,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.patientRegister);
                    },
                    child: Text(
                      "Sign up",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.primary,
                        fontSize: context.sp(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
