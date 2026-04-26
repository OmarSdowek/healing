import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/features/doctor/auth/presentation/cubit/doctor_auth_cubit.dart';
import 'package:healing/features/doctor/auth/presentation/cubit/doctor_auth_cubit_factory.dart';
import 'package:healing/features/doctor/profile/presentation/cubit/doctor_profile_cubit.dart';
import 'package:healing/features/doctor/profile/presentation/cubit/doctor_profile_cubit_factory.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../patient/profile/presentation/widgets/log_out_dailog.dart';
import '../../../../patient/profile/presentation/widgets/profile_option_item.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool notificationEnabled = false;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => LogoutDialog(
        btnText: "Logout",
        onCancel: () {
          Navigator.pop(dialogContext);
        },
        onConfirm: () {
          context.read<DoctorAuthCubit>().logout();
        },
        subtitle: "Are you sure you want to logout?",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DoctorAuthCubitFactory.create()),
        BlocProvider(
          create: (_) {
            final cubit = DoctorProfileCubitFactory.create();
            cubit.getProfile(); // Load profile when cubit is created
            return cubit;
          },
        ),
      ],
      child: BlocListener<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorLogoutSuccess) {
            Navigator.pop(context); // Close dialog
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.doctorLogin,
              (route) => false,
            );
          } else if (state is DoctorAuthError) {
            Navigator.pop(context); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
              builder: (context, state) {
                if (state is DoctorProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DoctorProfileError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DoctorProfileCubit>().getProfile();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DoctorProfileLoaded) {
                  final profile = state.profile;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        const CustomHeader(title: "Profile"),

                        context.verticalSpace(20),

                        CircleAvatar(
                          radius: context.r(80),
                          backgroundImage: profile.profileImage != null
                              ? NetworkImage(profile.profileImage!)
                              : AssetImage(AssetsManger.doctor2Image)
                                    as ImageProvider,
                        ),
                        context.verticalSpace(12),
                        Text(
                          profile.name ?? "Doctor",
                          style: AppTextStyles.reg20black,
                        ),
                        if (profile.specialization != null)
                          Text(
                            profile.specialization!,
                            style: AppTextStyles.semiBold16Black.copyWith(
                              color: AppColors.primary,
                            ),
                          ),

                        context.verticalSpace(20),

                        /// Notification Toggle
                        Container(
                          width: context.screenWidth,
                          height: context.h(50),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(context.r(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Notification",
                                style: AppTextStyles.semiBold16Black,
                              ),
                              Switch(
                                value: notificationEnabled,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  setState(() => notificationEnabled = val);
                                },
                              ),
                            ],
                          ),
                        ),

                        context.verticalSpace(20),

                        ProfileOptionItem(
                          icon: Icons.person,
                          title: "Personal information",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.doctorPersonalInformation,
                            );
                          },
                        ),
                        ProfileOptionItem(
                          icon: Icons.settings,
                          title: "Settings",
                          onTap: () {
                            Navigator.pushNamed(context, Routes.doctorSettings);
                          },
                        ),
                        ProfileOptionItem(
                          icon: Icons.lock,
                          title: "Manage Password",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.doctorManagePassword,
                            );
                          },
                        ),
                        ProfileOptionItem(
                          icon: Icons.logout,
                          title: "Logout",
                          textColor: Colors.red,
                          onTap: () => _showLogoutDialog(context),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
