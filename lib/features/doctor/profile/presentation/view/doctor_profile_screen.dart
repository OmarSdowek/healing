import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
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

              CircleAvatar(
                radius: context.r(80),
                backgroundImage: AssetImage(AssetsManger.doctor2Image),
              ),
              context.verticalSpace(12),
              Text("Rahma Ahmed", style: AppTextStyles.reg20black),

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

              ProfileOptionItem(
                icon: Icons.person,
                title: "Personal information",
                onTap: () {
                  Navigator.pushNamed(context, Routes.doctorPersonalInformation);
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
                  Navigator.pushNamed(context, Routes.doctorManagePassword);
                },
              ),
              ProfileOptionItem(
                icon: Icons.logout,
                title: "Logout",
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    builder: (context) => LogoutDialog(
                      btnText: "Logout",
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onConfirm: () {

                      },
                      subtitle: "Are you sure you want to logout?",
                    ),
                    context: context,
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
