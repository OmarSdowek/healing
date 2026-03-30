import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../home/presentation/widgets/appointment_card.dart';


class UpComingOppointment extends StatelessWidget {
  const UpComingOppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomHeader(title: "Upcoming Appointment"),
              context.verticalSpace(20),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                    itemBuilder: (context, index) {
                      return AppointmentCard(
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
                        status: AppointmentStatus.upcoming,
                      );
                    },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
