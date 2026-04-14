import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../domin/entity/medical_report_model.dart';
import '../widgets/medical_card.dart';
import 'medical_report_details.dart';


class MedicalReportListScreen extends StatelessWidget {
  const MedicalReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      MedicalReport(
        title: "Complete Blood Count (CBC)",
        status: "NORMAL",
        id: "#LB-9023",
        image: AssetsManger.doctor2Image,
        date: "Oct 24, 2023",
        diagnosis: "Acute Bronchitis",
        physician: "Dr. Sarah Jenkins",
        diagnosisDate: "Oct 24, 2023",
        symptoms: "Persistent cough, fatigue, mild chest congestion, occasional shortness of breath.",
        medication: "- Amoxicillin 500mg (3x Daily)\n- Albuterol Inhaler (As needed)",
        recommendations: "Maintain high fluid intake and ensure 8–10 hours of rest daily.\nAvoid irritants like smoke or strong fragrances.\nFollow-up appointment scheduled in 14 days.",
        oxygen: "96% (Within normal range 95%–100%)",
      ),
      MedicalReport(
        title: "Chest X-Ray PA View",
        status: "NORMAL",
        id: "#LB-9023",
        date: "Oct 2, 2024",
        image: AssetsManger.doctor2Image,
        diagnosis: "Acute Bronchitis",
        physician: "Dr. Sarah Jenkins",
        diagnosisDate: "Oct 24, 2023",
        symptoms: "Persistent cough, fatigue, mild chest congestion, occasional shortness of breath.",
        medication: "- Amoxicillin 500mg (3x Daily)\n- Albuterol Inhaler (As needed)",
        recommendations: "Maintain high fluid intake and ensure 8–10 hours of rest daily.\nAvoid irritants like smoke or strong fragrances.\nFollow-up appointment scheduled in 14 days.",
        oxygen: "96% (Within normal range 95%–100%)",
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.r(16)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: "Medical report"),
                context.verticalSpace(20),
            
                ...reports.map((report) => Padding(
                  padding: EdgeInsets.only(bottom: context.h(16)),
                  child: ReportCard(
                    report: report,
                    onView: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MedicalReportDetailScreen(report: report),
                        ),
                      );
                    },
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

