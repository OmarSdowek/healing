import 'package:flutter/material.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
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
        child: SingleChildScrollView(   // 🔹 هنا التغيير
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              const CustomHeader(title: "Profile"),

              context.verticalSpace(20),

              CircleAvatar(
                radius: context.r(80),
                backgroundImage: AssetImage(AssetsManger.person),
              ),
              context.verticalSpace(12),
              Text("Ahmed Mohamed", style: AppTextStyles.reg20black),

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

              /// Options (كلهم في نفس السكرول)
              ProfileOptionItem(
                icon: Icons.person,
                title: "Personal information",
                onTap: () {},
              ),
              ProfileOptionItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  Navigator.pushNamed(context, Routes.settings);
                },
              ),
              ProfileOptionItem(
                icon: Icons.payment,
                title: "Payment Method",
                onTap: () {},
              ),
              ProfileOptionItem(
                icon: Icons.description,
                title: "Medical Report",
                onTap: () {},
              ),
              ProfileOptionItem(
                icon: Icons.medication,
                title: "My Prescription",
                onTap: () {},
              ),
              ProfileOptionItem(
                icon: Icons.calendar_today,
                title: "My Appointment",
                onTap: () {},
              ),
              ProfileOptionItem(
                icon: Icons.logout,
                title: "Logout",
                textColor: Colors.red,
                onTap: () {
                   showDialog(
                    builder: (context) => LogoutDialog(
                      title: "Logout",
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
