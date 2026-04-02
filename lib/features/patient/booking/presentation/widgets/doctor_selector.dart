import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/widgets/custom_button.dart';
import 'doctor_profile.dart';



class DoctorSelector extends StatelessWidget {
  final Function(Map<String, String>) onDoctorSelected;

  const DoctorSelector({super.key, required this.onDoctorSelected});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: "Select Doctor",
      onPressed: () => _showDoctorList(context),
      backgroundColor: AppColors.primary,
      textColor: AppColors.primary,
      height: context.h(45),
      outlined: true,
    );
  }

  void _showDoctorList(BuildContext context) {
    final doctors = [
      {"name": "Mohamed Saeed", "speciality": "Physical Therapy", "image": AssetsManger.doctor3Image},
      {"name": "Ahmed Sayed", "speciality": "Orthopedic", "image": AssetsManger.doctorImage},
      {"name": "Manar Mostafa", "speciality": "Pediatrics", "image": AssetsManger.doctor2Image},
    ];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (_, i) {
            final d = doctors[i];
            return DoctorProfileSection(
              name: d["name"]!,
              speciality: d["speciality"]!,
              image: d["image"]!,
              onTap: () {
                onDoctorSelected(d);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

