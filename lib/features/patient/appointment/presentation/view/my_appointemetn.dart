import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../home/presentation/widgets/appointment_card.dart';

class MyAppointment extends StatelessWidget {
  const MyAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "My Appointments"),
              context.verticalSpace(20),

              /// Upcoming Section
              Text("Upcoming",
                  style: AppTextStyles.reg20black.copyWith(color: AppColors.primary)),
              context.verticalSpace(10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    date: "Monday, July 21 – 11:00 AM",
                    doctorName: "Mohamed Saeed",
                    speciality: "Physical Therapy",
                    image: AssetsManger.doctor3Image,
                    onCancel: () {},
                    onReschedule: () {},
                    status: AppointmentStatus.upcoming,
                  );
                },
              ),

              context.verticalSpace(20),

              /// Completed Section
              Text("Completed",
                  style: AppTextStyles.reg20black.copyWith(color: Colors.green)),
              context.verticalSpace(10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    date: "Monday, July 4 – 1:00 PM",
                    doctorName: "Mohamed Kamel",
                    speciality: "Dermatology",
                    image: AssetsManger.doctorImage,
                    onCancel: () {},
                    onReschedule: () {},
                    status: AppointmentStatus.completed,
                  );
                },
              ),

              context.verticalSpace(20),

              /// Canceled Section
              Text("Canceled",
                  style: AppTextStyles.reg20black.copyWith(color: Colors.red)),
              context.verticalSpace(10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    date: "Monday, July 14 – 8:30 AM",
                    doctorName: "Seif Ali",
                    speciality: "Physical Therapy",
                    image: AssetsManger.doctor2Image,
                    onCancel: () {},
                    onReschedule: () {},
                    status: AppointmentStatus.canceled,
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
