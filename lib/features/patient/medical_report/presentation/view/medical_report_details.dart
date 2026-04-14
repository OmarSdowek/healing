import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';

import '../../domin/entity/medical_report_model.dart';

class MedicalReportDetailScreen extends StatelessWidget {
  final MedicalReport report;

  const MedicalReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.r(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Medical report"),
              context.verticalSpace(20),

              Text("DIAGNOSIS", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              Text("${report.diagnosis} - ACTIVE", style: AppTextStyles.reg20black),
              context.verticalSpace(12),
              Text("Treating Physician: ${report.physician}", style: AppTextStyles.reg20black),
              Text("Date of Diagnosis: ${report.diagnosisDate}", style: AppTextStyles.semiBold16Black),

              context.verticalSpace(20),
              SectionWidget(title: "Symptoms", content: report.symptoms),
              context.verticalSpace(16),
              SectionWidget(title: "Prescribed Medication", content: report.medication),
              context.verticalSpace(16),
              SectionWidget(title: "Doctor’s Recommendations", content: report.recommendations),
              context.verticalSpace(16),
              SectionWidget(title: "Oxygen Saturation", content: report.oxygen),

              const Spacer(),
              CustomButton(
                text: "Download Pdf",
                onPressed: () {
                  // لوجيك تحميل PDF
                },
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final String content;

  const SectionWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.semiBold16Black),
        context.verticalSpace(6),
        Text(content, style: AppTextStyles.semiBold16Black),
      ],
    );
  }
}
