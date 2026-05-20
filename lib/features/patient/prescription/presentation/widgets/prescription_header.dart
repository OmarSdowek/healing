import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/widgets/doctor_avatar.dart';

class PrescriptionHeader extends StatelessWidget {
  final String doctorName;
  final String speciality;
  final String date;
  final String prescriptionId;
  final String? doctorImageUrl;

  const PrescriptionHeader({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.prescriptionId,
    this.doctorImageUrl,
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
              DoctorAvatar(pictureUrl: doctorImageUrl, radius: context.r(30)),
              context.horizontalSpace(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Remove "Dr." prefix if already in name to avoid "Dr. Dr."
                    doctorName.startsWith('Dr.') ? doctorName : "Dr. $doctorName",
                    style: AppTextStyles.reg20black,
                  ),
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
                    color: AppColors.primary.withValues(alpha: 0.1),
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
                    color: AppColors.primary.withValues(alpha: 0.1),
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
