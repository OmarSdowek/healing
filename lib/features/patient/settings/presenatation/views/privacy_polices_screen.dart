import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/constant/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Privacy Policy"),
              const SizedBox(height: 20),

              Text("Last Updated: 19/11/2024",
                  style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.grey)),
              const SizedBox(height: 12),

              Text(
                "Welcome to Cure. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our doctor appointment booking app.",
                style: AppTextStyles.semiBold16Black,
              ),

              const SizedBox(height: 20),

              Text("Terms & Conditions",
                  style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.primary)),
              const SizedBox(height: 8),

              Text(
                "By registering, accessing, or using this app, you confirm that you are at least 18 years old (or have parental/guardian consent if younger) and agree to be bound by these Terms and our Privacy Policy.\n\n"
                    "You agree to:\n- Use the app only for lawful purposes.\n- Provide accurate and complete information during registration and booking.\n- Not impersonate others or create fake accounts.\n\n"
                    "You may not:\n- Disrupt or interfere with the app’s functionality.\n- Try to access data or systems not meant for you.\n- Use the app to harass or abuse doctors or staff.\n\n"
                    "Your data is handled in accordance with our Privacy Policy. You are responsible for keeping your login credentials secure.",
                style: AppTextStyles.semiBold16Black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
