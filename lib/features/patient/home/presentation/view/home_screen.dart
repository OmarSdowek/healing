import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/features/patient/home/presentation/widgets/profile_header.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../widgets/doctor_card.dart';
import '../widgets/speciality_section.dart';
import '../widgets/up_coming_appointement_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 🔹 مهم علشان النصوص تبقى ببداية السطر
              children: [
                /// Header
                ProfileHeader(name: "omar sayed", image: AssetsManger.person),

                context.verticalSpace(20),

                /// Search Bar
                CustomTextFormField(
                    hintText: "Search for specialty, doctor",
                    controller: TextEditingController(),
                    prefixIcon: Icon(Icons.search, color: AppColors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.search);
                  },
                  ),


                context.verticalSpace(20),

                /// Banner
                Image.asset(
                  AssetsManger.home,
                  height: context.h(200),
                  width: context.screenWidth,
                  fit: BoxFit.cover,
                ),

                context.verticalSpace(20),

                /// Specialities
                SpecialitiesSection(
                  specialities: [
                    {"title": "Neurology", "icon": AssetsManger.person},
                    {"title": "Phoniatrics", "icon": AssetsManger.person},
                    {"title": "Endocrinology", "icon": AssetsManger.person},
                  ],
                ),

                context.verticalSpace(20),

                /// Upcoming Appointment
                const UpcomingAppointmentSection(),

                context.verticalSpace(20),

                /// Available Doctors Title
                Text(
                  "Available Doctors",
                  style: AppTextStyles.reg20black.copyWith(
                    color: AppColors.black,
                  ),
                ),

                context.verticalSpace(20),

                /// Doctor Cards
                DoctorCard(
                  name: "Dr. Reham Saeed",
                  speciality: "Neurology Specialist",
                  price: "350 EGP/hour",
                  image: AssetsManger.doctorImage,
                ),
                DoctorCard(
                  name: "Dr. Zain Ahmed",
                  speciality: "Cardiology Specialist",
                  price: "350 EGP/hour",
                  image: AssetsManger.doctor2Image,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
