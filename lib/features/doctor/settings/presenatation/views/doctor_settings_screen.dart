import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/token_storage.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../patient/profile/presentation/widgets/log_out_dailog.dart';
import '../../../../patient/profile/presentation/widgets/profile_option_item.dart';

class DoctorSettingsScreen extends StatefulWidget {
  const DoctorSettingsScreen({super.key});

  @override
  State<DoctorSettingsScreen> createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  bool _isDeleting = false;

  Future<void> _handleDeleteAccount() async {
    setState(() => _isDeleting = true);

    try {
      // TODO: Call API to delete account
      // For now, just clear tokens and logout
      await TokenStorage.clearTokens();

      if (mounted) {
        // Close the dialog
        Navigator.pop(context);

        // Navigate to login screen and clear navigation stack
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.doctorLogin,
          (route) => false,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete account. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteDialog() {
    if (_isDeleting) return;

    showDialog(
      context: context,
      barrierDismissible: !_isDeleting,
      builder: (_) => LogoutDialog(
        onCancel: () {
          if (!_isDeleting) {
            Navigator.pop(context);
          }
        },
        onConfirm: _handleDeleteAccount,
        subtitle:
            'Are you sure you want to delete your account? This action cannot be undone.',
        btnText: _isDeleting ? "Deleting..." : "Delete",
      ),
    );
  }

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
                  Navigator.pushNamed(context, Routes.doctorFaqs);
                },
              ),
              ProfileOptionItem(
                icon: Icons.privacy_tip,
                title: "Privacy Policy",
                onTap: () {
                  Navigator.pushNamed(context, Routes.doctorPrivacyPolicy);
                },
              ),
              ProfileOptionItem(
                icon: Icons.delete_forever,
                title: "Delete account",
                textColor: Colors.red,
                onTap: _showDeleteDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
