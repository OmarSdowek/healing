import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../../core/route/routes.dart';
import '../widgets/day_selector.dart';
import '../widgets/doctor_profile.dart';
import '../widgets/doctor_selector.dart';
import '../widgets/price_pay_section.dart';
import '../widgets/time_selector.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  String selectedTime = "11:00 AM";
  Map<String, String>? selectedDoctor; // ✅ نخزن بيانات الدكتور هنا

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(10),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const CustomHeader(title: "Book Appointment"),
              context.verticalSpace(20),

              /// Doctor Selector OR Profile
              selectedDoctor == null
                  ? DoctorSelector(
                      onDoctorSelected: (doctor) {
                        setState(() {
                          selectedDoctor = doctor;
                        });
                      },
                    )
                  : DoctorProfileSection(
                      name: selectedDoctor!["name"]!,
                      speciality: selectedDoctor!["speciality"]!,
                      image: selectedDoctor!["image"]!,
                    ),

              context.verticalSpace(20),

              /// Day Selector
              DaySelector(
                focusedDay: focusedDay,
                selectedDay: selectedDay,
                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    focusedDay = focused;
                  });
                },
              ),

              context.verticalSpace(20),

              /// Time Selector
              TimeSelector(
                selectedTime: selectedTime,
                onSelect: (time) {
                  setState(() => selectedTime = time);
                },
              ),

              context.verticalSpace(100),
            ],
          ),
        ),
      ),

      /// Price & Pay Section ثابت تحت
      bottomNavigationBar: PriceAndPaySection(
        text: "Continue Pay",
        price: 285,
        onPressed: () {
        Navigator.pushNamed(context, Routes.pay);
      },),
    );
  }
}
