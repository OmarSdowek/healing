import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/constant/app_colors.dart';

class MedicationItem extends StatelessWidget {
  final String name;
  final String dosage;
  final String duration;      // عدد الأيام
  final String instructions;

  const MedicationItem({
    super.key,
    required this.name,
    required this.dosage,
    required this.duration,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.screenHeight * 0.01),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// اسم الدواء + Badge للمدة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  duration,
                  style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),

          context.verticalSpace(6),

          /// الجرعة
          Text(
            dosage,
            style: AppTextStyles.semiBold16Black.copyWith(color: Colors.grey),
          ),

          context.verticalSpace(6),

          /// التعليمات
          Text(
            instructions,
            style: AppTextStyles.semiBold16Black,
          ),
        ],
      ),
    );
  }
}
