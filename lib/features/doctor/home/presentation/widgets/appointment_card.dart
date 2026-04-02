import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

class AppointmentCard extends StatelessWidget {
  final String date;
  final String patientName;
  final int age;
  final String diagnosis;
  final String patientImage;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback? onAddPrescription;
  final VoidCallback? onOpenRecord;

  const AppointmentCard({
    super.key,
    required this.date,
    required this.patientName,
    required this.age,
    required this.diagnosis,
    required this.patientImage,
    required this.statusLabel,
    required this.statusColor,
    this.onAddPrescription,
    this.onOpenRecord,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: context.sp(14),
                color: AppColors.grey,
              ),
              context.horizontalSpace(6),
              Text(
                date,
                style: AppTextStyles.semiBold16Black.copyWith(
                  fontSize: context.sp(13),
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              Text(
                statusLabel,
                style: AppTextStyles.semiBold16Black.copyWith(
                  fontSize: context.sp(13),
                  color: statusColor,
                ),
              ),
            ],
          ),
          context.verticalSpace(12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  patientImage,
                  width: context.w(60),
                  height: context.h(60),
                  fit: BoxFit.cover,
                ),
              ),
              context.horizontalSpace(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: AppTextStyles.semiBold16Black.copyWith(
                      fontSize: context.sp(15),
                      color: AppColors.primaryText,
                    ),
                  ),
                  context.verticalSpace(4),
                  Text(
                    "$age",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      fontSize: context.sp(13),
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  context.verticalSpace(2),
                  Text(
                    diagnosis,
                    style: AppTextStyles.semiBold16Black.copyWith(
                      fontSize: context.sp(13),
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          context.verticalSpace(14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onAddPrescription,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Add Prescription",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.primary,
                      fontSize: context.sp(13),
                    ),
                  ),
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Open Record",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.white,
                      fontSize: context.sp(13),
                    ),
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
