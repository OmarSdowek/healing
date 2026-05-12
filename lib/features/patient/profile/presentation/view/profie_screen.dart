import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../widgets/log_out_dailog.dart';
import '../widgets/profile_option_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              const CustomHeader(title: "Profile"),

              context.verticalSpace(20),

              /// Profile Picture — shows default since /api/Auth/me doesn't return pictureUrl
              CircleAvatar(
                radius: context.r(80),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: context.r(70),
                  color: AppColors.primary,
                ),
              ),
              context.verticalSpace(12),

              /// User Name
              BlocBuilder<PatientAuthCubit, PatientAuthState>(
                builder: (context, state) {
                  if (state is PatientDataSuccess) {
                    return Text(
                      state.meData.fullName,
                      style: AppTextStyles.reg20black,
                    );
                  }
                  return Text("Loading...", style: AppTextStyles.reg20black);
                },
              ),

              context.verticalSpace(20),

              /// Notification Toggle
              Container(
                width: context.screenWidth,
                height: context.h(50),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(context.r(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Notification", style: AppTextStyles.semiBold16Black),
                    Switch(
                      value: notificationEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() => notificationEnabled = val);
                      },
                    ),
                  ],
                ),
              ),

              context.verticalSpace(20),

              /// Profile Options
              ProfileOptionItem(
                icon: Icons.person,
                title: "Personal information",
                onTap: () {
                  Navigator.pushNamed(context, Routes.personalInformation);
                },
              ),
              ProfileOptionItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  Navigator.pushNamed(context, Routes.settings);
                },
              ),
              ProfileOptionItem(
                icon: Icons.description,
                title: "Medical Report",
                onTap: () {
                  Navigator.pushNamed(context, Routes.patientMedicalReport);
                },
              ),
              ProfileOptionItem(
                icon: Icons.medication,
                title: "My Prescription",
                onTap: () {
                  Navigator.pushNamed(context, Routes.prescriptionDetails);
                },
              ),
              ProfileOptionItem(
                icon: Icons.calendar_today,
                title: "My Appointment",
                onTap: () {
                  Navigator.pushNamed(context, Routes.myAppointments);
                },
              ),

              /// Logout Button
              ProfileOptionItem(
                icon: Icons.logout,
                title: "Logout",
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
                          if (state is PatientLoggedOut) {
                            // Close dialog
                            Navigator.pop(dialogContext);
                            // Navigate to login and clear stack
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.patientLogin,
                              (route) => false,
                            );
                          } else if (state is PatientAuthError) {
                            Navigator.pop(dialogContext);
                            AppSnackBar.showError(context, state.message);
                          }
                        },
                        builder: (context, state) {
                          return LogoutDialog(
                            onCancel: () {
                              Navigator.pop(dialogContext);
                            },
                            onConfirm: () {
                              print("🔥 Logout button pressed");
                              context.read<PatientAuthCubit>().logout();
                            },
                            btnText: state is PatientAuthLoading
                                ? "Logging out..."
                                : "Logout",
                            subtitle: "Are you sure you want to logout?",
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
