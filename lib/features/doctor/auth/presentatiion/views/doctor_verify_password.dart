// Not used in the doctor flow — doctor verify is handled by DoctorOtpEmail.
// Kept as a placeholder to avoid route errors.
import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../../core/route/routes.dart';

class DoctorVerifyPassword extends StatelessWidget {
  const DoctorVerifyPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: 'Verify Account'),
            context.verticalSpace(40),
            const Center(
              child: CircularProgressIndicator(),
            ),
            context.verticalSpace(20),
            Center(
              child: Text(
                'Redirecting...',
                style: AppTextStyles.semiBold16Black
                    .copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
