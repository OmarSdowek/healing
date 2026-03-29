import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../profile/presentation/widgets/log_out_dailog.dart';
import '../../../profile/presentation/widgets/profile_option_item.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Settings"),

              context.verticalSpace(20),

              /// Options
              ProfileOptionItem(
                icon: Icons.help_outline,
                title: "FAQs",
                onTap: () {
                  Navigator.pushNamed(context, Routes.faqs);
                },
              ),
              ProfileOptionItem(
                icon: Icons.privacy_tip,
                title: "Privacy Policy",
                onTap: () {
                  Navigator.pushNamed(context, Routes.privacyPolicy);
                },
              ),
              ProfileOptionItem(
                icon: Icons.lock,
                title: "Manage Password",
                onTap: () {
                  Navigator.pushNamed(context, Routes.mangePassword);
                },
              ),
              ProfileOptionItem(
                icon: Icons.delete_forever,
                title: "Delete account",
                textColor: Colors.red,
                onTap: () {
                  // افتح Dialog تأكيد الحذف
                  showDialog(
                    context: context,
                    builder: (_) => LogoutDialog(
                      onCancel: () => Navigator.pop(context),
                      onConfirm: () {
                        Navigator.pop(context);
                        // 🔹 هنا تعمل لوجيك حذف الحساب
                      }, title: 'Delete Account',
                      subtitle: 'Are you sure you want to delete your account?',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
