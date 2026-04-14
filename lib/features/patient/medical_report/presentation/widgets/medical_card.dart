import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';

import '../../domin/entity/medical_report_model.dart';

class ReportCard extends StatelessWidget {
  final MedicalReport report;
  final VoidCallback onView;
   // 🔹 لون اللابل (أخضر / برتقالي)

  const ReportCard({
    super.key,
    required this.report,
    required this.onView,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 صورة التحليل مع لابل الحالة
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.r(12)),
                  topRight: Radius.circular(context.r(12)),
                ),
                child: Image.asset(
                  report.image,
                  height: context.h(140),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: context.h(8),
                right: context.w(8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(6)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  child: Text(
                    report.status,
                    style: AppTextStyles.semiBold16Black.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(context.r(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 LABORATORY
                Text("LABORATORY", style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.primaryDark)),
                context.verticalSpace(8),

                /// 🔹 ID
                Text("ID: ${report.id}", style: AppTextStyles.semiBold16Black),
                context.verticalSpace(4),

                /// 🔹 Title
                Text(report.title, style: AppTextStyles.semiBold16Black),
                context.verticalSpace(4),

                /// 🔹 Date
                Text("Date: ${report.date}", style: AppTextStyles.semiBold16Black),

                context.verticalSpace(16),

                /// 🔹 View Button
                CustomButton(
                  text: "View",
                  onPressed: onView,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
