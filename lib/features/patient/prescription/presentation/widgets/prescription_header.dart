import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/constant/app_colors.dart';
import '../../../../../core/constant/assets_manger.dart';

class PrescriptionHeader extends StatelessWidget {
  final String doctorName;
  final String speciality;
  final String date;
  final String prescriptionId;

  const PrescriptionHeader({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.prescriptionId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Doctor Info
          Row(
            children: [
              CircleAvatar(
                radius: context.r(30),
                backgroundImage: AssetImage(AssetsManger.doctorImage),
              ),
              context.horizontalSpace(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dr. $doctorName", style: AppTextStyles.reg20black),
                  context.verticalSpace(4),
                  Text(
                    speciality,
                    style: AppTextStyles.semiBold16Black.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          context.verticalSpace(16),

          /// Date & Prescription ID in separate containers
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  child: Text(
                    "Date: $date",
                    style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  child: Text(
                    "ID: $prescriptionId",
                    style: AppTextStyles.semiBold16Black.copyWith(color: Colors.blueGrey),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
