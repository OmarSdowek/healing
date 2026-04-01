import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

class PatientSummaryCard extends StatelessWidget {
  final String name;
  final int age;
  final String mrn;
  final String bloodType;
  final String weight;
  final String imageAsset;

  const PatientSummaryCard({
    super.key,
    required this.name,
    required this.age,
    required this.mrn,
    required this.bloodType,
    required this.weight,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageAsset,
              width: context.w(56),
              height: context.h(56),
              fit: BoxFit.cover,
            ),
          ),
          context.horizontalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.semiBold16Black.copyWith(
                  fontSize: context.sp(15),
                  color: AppColors.primaryText,
                ),
              ),
              context.verticalSpace(4),
              Text(
                "Age: $age  |  MRN: $mrn",
                style: AppTextStyles.semiBold16Black.copyWith(
                  fontSize: context.sp(12),
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              context.verticalSpace(6),
              Row(
                children: [
                  _Badge(
                    label: "BLOOD: $bloodType",
                    color: const Color(0xFFFF8C42),
                  ),
                  context.horizontalSpace(8),
                  _Badge(
                    label: "WEIGHT: $weight",
                    color: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.sp(10),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
