import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';
import '../../../doctors/presentation/view/doctors_screen.dart';

class SpecialityItem extends StatelessWidget {
  final String title;
  final String iconPath;
  const SpecialityItem({super.key, required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       Navigator.pushNamed(context, Routes.doctors);
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, height: 32, width: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
