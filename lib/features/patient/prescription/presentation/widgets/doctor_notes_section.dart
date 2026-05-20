import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/constant/app_colors.dart';

class DoctorNotesSection extends StatelessWidget {
  final String notes;
  final String doctorName;

  const DoctorNotesSection({
    super.key,
    required this.notes,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellowAccent.withValues(alpha: 0.35),
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
          /// العنوان
          Text(
            "Doctor's Notes",
            style: AppTextStyles.reg20black.copyWith(color: AppColors.primary),
          ),
          context.verticalSpace(12),

          /// النص
          Text(
            notes,
            style: AppTextStyles.semiBold16Black.copyWith(color: Colors.black87),
          ),

          context.verticalSpace(20),

          /// توقيع الدكتور
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Dr. $doctorName, M.D.",
              style: AppTextStyles.semiBold16Black.copyWith(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
