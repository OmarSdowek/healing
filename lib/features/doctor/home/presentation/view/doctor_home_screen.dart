import 'package:flutter/material.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/features/doctor/home/presentation/widgets/appointment_card.dart';
import 'package:healing/features/doctor/home/presentation/widgets/doctor_home_header.dart';
import 'package:healing/features/doctor/home/presentation/widgets/today_appointment_section.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              context.verticalSpace(16),

              const DoctorHomeHeader(
                name: "Dr. Reham",
                imageAsset: AssetsManger.doctorImage,
              ),

              context.verticalSpace(24),

              const TodayAppointmentSection(),

              context.verticalSpace(24),

              _AppointmentListSection(
                title: "Upcoming Appointment",
                cards: [
                  AppointmentCard(
                    date: "Monday, July 21 - 11:00 Am",
                    patientName: "Mohamed Ahmed",
                    age: 22,
                    diagnosis: "Influenza",
                    patientImage: AssetsManger.person,
                    statusLabel: "Next Appointment",
                    statusColor: const Color(0xFF7C3AED),
                    onAddPrescription: () {},
                    onOpenRecord: () {},
                  ),
                ],
              ),

              context.verticalSpace(24),

              _AppointmentListSection(
                title: "Recent Appointment",
                cards: [
                  AppointmentCard(
                    date: "Monday, July 21 - 9:00 Am",
                    patientName: "Sayed Ahmed",
                    age: 50,
                    diagnosis: "Influenza",
                    patientImage: AssetsManger.person,
                    statusLabel: "Completed",
                    statusColor: Colors.green,
                    onAddPrescription: () {},
                    onOpenRecord: () {},
                  ),
                ],
              ),

              context.verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentListSection extends StatelessWidget {
  final String title;
  final List<Widget> cards;

  const _AppointmentListSection({required this.title, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: context.sp(18),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                "View All",
                style: TextStyle(
                  color: const Color(0xFF1F2B6C),
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        context.verticalSpace(12),
        ...cards,
      ],
    );
  }
}
