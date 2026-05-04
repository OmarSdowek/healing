import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
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
                  // ✅ Get the cubit before opening dialog
                  final cubit = context.read<PatientAuthCubit>();
                  
                  showDialog(
                    context: context,
                    builder: (dialogContext) => BlocProvider.value(
                      value: cubit, // ✅ Pass existing cubit to dialog
                      child: BlocConsumer<PatientAuthCubit, PatientAuthState>(
                        listener: (context, state) {
                          if (state is PatientAccountDeletedSuccess) {
                            Navigator.pop(dialogContext);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.patientLogin,
                              (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Account deleted successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (state is PatientAuthError) {
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          // Get user ID from current state
                          String? userId;
                          if (state is PatientDataSuccess) {
                            userId = state.meData.id;
                          }

                          return LogoutDialog(
                            onCancel: () => Navigator.pop(dialogContext),
                            onConfirm: () {
                              if (userId != null) {
                                print("🔥 Delete account button pressed for user: $userId");
                                context.read<PatientAuthCubit>().deleteAccount(userId);
                              } else {
                                Navigator.pop(dialogContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Unable to get user ID"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            btnText: state is PatientAuthLoading ? "Deleting..." : "Delete",
                            subtitle: 'Are you sure you want to delete your account?',
                          );
                        },
                      ),
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
