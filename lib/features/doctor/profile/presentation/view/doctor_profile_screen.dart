import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit_factory.dart';
import '../../../../patient/profile/presentation/widgets/log_out_dailog.dart';
import '../../../../patient/profile/presentation/widgets/profile_option_item.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _notificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorAuthCubitFactory.create(),
      child: BlocListener<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorAuthLoggedOut) {
            Navigator.pushReplacementNamed(context, Routes.doctorLogin);
          }
          if (state is DoctorAuthError) {
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(12),
                vertical: context.h(12),
              ),
              child: Column(
                children: [
                  const CustomHeader(title: "Profile"),
                  context.verticalSpace(20),

                  CircleAvatar(
                    radius: context.r(80),
                    backgroundImage: const AssetImage(
                      AssetsManger.doctor2Image,
                    ),
                  ),
                  context.verticalSpace(12),
                  Text("Dr. Reham Ahmed", style: AppTextStyles.reg20black),

                  context.verticalSpace(20),

                  // Notification toggle
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(4),
                    ),
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
                          value: _notificationEnabled,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) =>
                              setState(() => _notificationEnabled = val),
                        ),
                      ],
                    ),
                  ),

                  context.verticalSpace(20),

                  ProfileOptionItem(
                    icon: Icons.person,
                    title: "Personal information",
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.doctorPersonalInformation,
                    ),
                  ),
                  ProfileOptionItem(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.doctorSettings),
                  ),
                  ProfileOptionItem(
                    icon: Icons.lock,
                    title: "Manage Password",
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.doctorManagePassword,
                    ),
                  ),
                  ProfileOptionItem(
                    icon: Icons.logout,
                    title: "Logout",
                    textColor: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => LogoutDialog(
                          btnText: "Logout",
                          subtitle: "Are you sure you want to logout?",
                          onCancel: () => Navigator.pop(dialogCtx),
                          onConfirm: () {
                            Navigator.pop(dialogCtx);
                            context.read<DoctorAuthCubit>().logout();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
