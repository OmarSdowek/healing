import 'package:flutter/material.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/doctor/home/presentation/widgets/appointment_card.dart';

class DoctorScheduleScreen extends StatelessWidget {
  const DoctorScheduleScreen({super.key});

  static const _appointments = [
    {
      "date": "Monday, July 21 - 10:00 Am",
      "name": "Mohamed Ahmed",
      "age": 22,
      "diagnosis": "Influenza",
    },
    {
      "date": "Monday, July 21 - 11:00 Am",
      "name": "Menna Ziad",
      "age": 18,
      "diagnosis": "Influenza",
    },
    {
      "date": "Monday, July 21 - 12:00 Am",
      "name": "Eman Reda",
      "age": 32,
      "diagnosis": "Influenza",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(title: "Upcoming Appointment"),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(12),
                ),
                itemCount: _appointments.length,
                separatorBuilder: (_, __) => context.verticalSpace(16),
                itemBuilder: (context, index) {
                  final a = _appointments[index];
                  return AppointmentCard(
                    date: a["date"] as String,
                    patientName: a["name"] as String,
                    age: a["age"] as int,
                    diagnosis: a["diagnosis"] as String,
                    patientImage: AssetsManger.person,
                    statusLabel: "Next Appointment",
                    statusColor: const Color(0xFF7C3AED),
                    onAddPrescription: () {
                      Navigator.pushNamed(
                        context,
                        Routes.addPrescription,
                        arguments: {
                          'patientName': a["name"] as String,
                          'patientAge': a["age"] as int,
                          'patientMrn': '#MRN-29384',
                          'patientBloodType': 'O+',
                          'patientWeight': '78KG',
                          'patientImage': AssetsManger.person,
                        },
                      );
                    },
                    onOpenRecord: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
