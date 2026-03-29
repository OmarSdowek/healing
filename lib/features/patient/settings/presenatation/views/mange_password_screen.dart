import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_feild.dart';

class ManagePasswordScreen extends StatelessWidget {
  const ManagePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Manage Password"),
              context.verticalSpace(20),

              /// Current password
              Text("Current password",
                style: AppTextStyles.semiBold16Black,),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter your password",
                controller: currentController,
                isPassword: true,
                prefixIcon: const Icon(Icons.remove_red_eye),
              ),

              context.verticalSpace(16),

              /// New password
              Text("New password",
                style: AppTextStyles.semiBold16Black,),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter your password",
                controller: newController,
                isPassword: true,
                prefixIcon: const Icon(Icons.remove_red_eye),
              ),

              context.verticalSpace(16),

              /// Confirm new password
              Text("Confirm new password",
                  style: AppTextStyles.semiBold16Black,),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Confirm new password",
                controller: confirmController,
                isPassword: true,
                prefixIcon: const Icon(Icons.remove_red_eye),
              ),

              const Spacer(),

              /// زر تغيير الباسورد
              CustomButton(
                text: "Change Password",
                onPressed: () {
                  // 🔹 هنا تعمل لوجيك تغيير الباسورد
                },
                height: 48,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
