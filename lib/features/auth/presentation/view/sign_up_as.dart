import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';

import '../../../../core/route/routes.dart';

class SignUpAsScreen extends StatelessWidget {
  const SignUpAsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            context.verticalSpace(330),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetsManger.logo,
                  height: 61,
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

            const SizedBox(height: 120),

            Text(
              "Sign up As",
              style: AppTextStyles.semiBold24dark.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Patient",
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.patientLogin);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: "Doctor",
                      outlined: true,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.primary,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.doctorLogin);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyles.reg20black,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Login
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
            ),
          ],
        ),
      ),
    );
  }
}
