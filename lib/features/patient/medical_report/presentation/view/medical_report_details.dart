import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../manger/medical_report_cubit.dart';

class MedicalReportDetailScreen extends StatelessWidget {
  final String reportId;

  const MedicalReportDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MedicalReportCubit>()..loadReportDetail(reportId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocBuilder<MedicalReportCubit, MedicalReportState>(
            builder: (context, state) {
              if (state is MedicalReportLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MedicalReportError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(state.message,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.red.shade700)),
                      ],
                    ),
                  ),
                );
              }

              if (state is MedicalReportDetailLoaded) {
                final r = state.detail;
                return Padding(
                  padding: EdgeInsets.all(context.r(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeader(title: "Medical report"),
                      context.verticalSpace(20),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Type + Status
                              Row(
                                children: [
                                  Text(
                                    r.type.toUpperCase(),
                                    style: AppTextStyles.semiBold16Black
                                        .copyWith(
                                            color: AppColors.primaryDark),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: r.status.toLowerCase() ==
                                              'active'
                                          ? Colors.green.shade100
                                          : Colors.grey.shade200,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      r.status.toUpperCase(),
                                      style: AppTextStyles.semiBold16Black
                                          .copyWith(
                                        color: r.status.toLowerCase() ==
                                                'active'
                                            ? Colors.green.shade800
                                            : Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              context.verticalSpace(8),

                              Text(r.title,
                                  style: AppTextStyles.reg20black),
                              context.verticalSpace(6),
                              Text(
                                  "Treating Physician: ${r.treatingPhysician}",
                                  style: AppTextStyles.reg20black),
                              Text(
                                  "Date of Diagnosis: ${r.dateOfDiagnosis}",
                                  style: AppTextStyles.semiBold16Black),

                              context.verticalSpace(20),

                              Text("Report Details",
                                  style: AppTextStyles.semiBold24dark
                                      .copyWith(
                                          color: AppColors.black)),
                              context.verticalSpace(12),

                              /// Symptoms
                              _SectionCard(
                                icon: Icons.sick_outlined,
                                title: "Symptoms",
                                content: r.symptoms.join('\n'),
                              ),
                              context.verticalSpace(12),

                              /// Prescribed Medication
                              _SectionCard(
                                icon: Icons.medication_outlined,
                                title: "Prescribed Medication",
                                content: r.prescribedMedication
                                    .map((m) => "• $m")
                                    .join('\n'),
                              ),
                              context.verticalSpace(12),

                              /// Doctor's Recommendations
                              _SectionCard(
                                icon: Icons.recommend_outlined,
                                title: "Doctor's Recommendations",
                                content: r.doctorRecommendations,
                              ),
                              context.verticalSpace(12),

                              /// Metrics
                              ...r.metrics.map((m) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 12),
                                    child: _MetricCard(metric: m),
                                  )),

                              context.verticalSpace(20),
                            ],
                          ),
                        ),
                      ),

                      /// Download PDF
                      CustomButton(
                        text: "Download Pdf",
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Download feature coming soon")),
                          );
                        },
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        height: 48,
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: AppTextStyles.semiBold16Black
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: AppTextStyles.semiBold16Black),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final dynamic metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final pct = (metric.value as num).toDouble();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(metric.name,
                  style: AppTextStyles.semiBold16Black
                      .copyWith(color: AppColors.primary)),
              const Spacer(),
              Text(
                "${metric.value}${metric.unit}",
                style: AppTextStyles.semiBold16Black,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct / 100,
              backgroundColor: Colors.grey.shade200,
              color: AppColors.primary,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Within normal range ${metric.range}",
            style: AppTextStyles.semiBold16Black
                .copyWith(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
