import 'package:flutter/material.dart';
import 'package:healing/core/constant/assets_manger.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import 'appointment_card.dart';

class UpcomingAppointmentSection extends StatelessWidget {
  const UpcomingAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Upcoming Appointment", style: AppTextStyles.reg20black),
              TextButton(
                onPressed: () {},
                child: Text("View all",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.primary,
                    )),
              ),
            ],
          ),
        ),

        /// Appointment Card
        AppointmentCard(
          date: "Monday, July 21 – 11:00 AM",
          doctorName: "Mohamed Saeed",
          speciality: "Physical Therapy",
          image: AssetsManger.doctor2Image,
          onCancel: () {
            // Cancel logic
          },
          onReschedule: () {
            // Reschedule logic
          },
        ),
      ],
    );
  }
}
