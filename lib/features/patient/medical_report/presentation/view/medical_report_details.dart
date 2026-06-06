import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/services/gemini_service.dart';
import 'package:healing/core/widgets/ai_summary_sheet.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/doctor_avatar.dart';
import '../manger/medical_report_cubit.dart';
import '../../../medical_report/domin/entity/medical_report_entity.dart';

class MedicalReportDetailScreen extends StatelessWidget {
  final String reportId;
  final MedicalReportEntity? report;

  const MedicalReportDetailScreen({
    super.key,
    required this.reportId,
    this.report,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MedicalReportCubit>()..loadReportDetail(reportId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocBuilder<MedicalReportCubit, MedicalReportState>(
            builder: (context, state) {
              if (state is MedicalReportLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MedicalReportError && report != null) {
                return _buildFromEntity(context, report!);
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
                            style: TextStyle(color: Colors.red.shade700)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<MedicalReportCubit>()
                              .loadReportDetail(reportId),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is MedicalReportDetailLoaded) {
                return _buildDetail(context, state.detail);
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, dynamic r) {
    return Padding(
      padding: EdgeInsets.all(context.r(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomHeader(title: 'Medical report'),
          context.verticalSpace(16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReportImage(imageUrl: r.reportImageUrl, status: r.status),
                  context.verticalSpace(16),
                  Row(
                    children: [
                      Text(
                        r.type.isNotEmpty ? r.type.toUpperCase() : 'DIAGNOSIS',
                        style: AppTextStyles.semiBold16Black
                            .copyWith(color: AppColors.primaryDark),
                      ),
                      const Spacer(),
                      _StatusBadge(status: r.status),
                    ],
                  ),
                  context.verticalSpace(6),
                  Text(r.title, style: AppTextStyles.reg20black),
                  context.verticalSpace(8),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoChip(
                          label: 'Treating Physician',
                          value: r.treatingPhysician.isNotEmpty
                              ? r.treatingPhysician
                              : 'N/A',
                        ),
                      ),
                      context.horizontalSpace(12),
                      Expanded(
                        child: _InfoChip(
                          label: 'Date of Diagnosis',
                          value: r.dateOfDiagnosis.isNotEmpty
                              ? r.dateOfDiagnosis
                              : r.date,
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(20),
                  Text('Report Details',
                      style: AppTextStyles.semiBold24dark
                          .copyWith(color: AppColors.black)),
                  context.verticalSpace(12),
                  if (r.symptoms.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.sick_outlined,
                      title: 'Symptoms',
                      content: r.symptoms.join('\n'),
                    ),
                    context.verticalSpace(12),
                  ],
                  if (r.prescribedMedication.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.medication_outlined,
                      title: 'Prescribed Medication',
                      content:
                          r.prescribedMedication.map((m) => '• $m').join('\n'),
                    ),
                    context.verticalSpace(12),
                  ],
                  if (r.doctorRecommendations.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.recommend_outlined,
                      title: "Doctor's Recommendations",
                      content: r.doctorRecommendations,
                    ),
                    context.verticalSpace(12),
                  ],
                  ...r.metrics.map<Widget>((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MetricCard(metric: m),
                      )),
                  context.verticalSpace(20),
                ],
              ),
            ),
          ),
          // ── AI Summary Button ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomButton(
              text: '✨ Generate AI Summary',
              backgroundColor: AppColors.primary.withOpacity(0.1),
              textColor: AppColors.primary,
              height: 48,
              onPressed: () => AiSummarySheet.show(
                context,
                title: 'Medical Record Summary',
                generateFn: () => GeminiService.generateMedicalSummary(
                  diagnosis: r.title,
                  clinicalNotes: r.doctorRecommendations.isNotEmpty
                      ? r.doctorRecommendations
                      : null,
                  vitals: r.metrics.isNotEmpty
                      ? r.metrics
                          .map((m) => '${m.name}: ${m.value}${m.unit}')
                          .join(', ')
                      : null,
                ),
              ),
            ),
          ),
          CustomButton(
            text: 'Download Pdf',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download feature coming soon')),
            ),
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            height: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildFromEntity(BuildContext context, MedicalReportEntity r) {
    return Padding(
      padding: EdgeInsets.all(context.r(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomHeader(title: 'Medical report'),
          context.verticalSpace(16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReportImage(imageUrl: r.thumbnailUrl, status: r.status),
                  context.verticalSpace(16),
                  Row(
                    children: [
                      Text(
                        r.type.isNotEmpty ? r.type.toUpperCase() : 'DIAGNOSIS',
                        style: AppTextStyles.semiBold16Black
                            .copyWith(color: AppColors.primaryDark),
                      ),
                      const Spacer(),
                      _StatusBadge(status: r.status),
                    ],
                  ),
                  context.verticalSpace(6),
                  Text(
                    r.title.isNotEmpty ? r.title : 'Medical Record',
                    style: AppTextStyles.reg20black,
                  ),
                  context.verticalSpace(8),
                  Row(
                    children: [
                      if (r.doctorName != null && r.doctorName!.isNotEmpty) ...[
                        Expanded(
                          child: _InfoChip(
                            label: 'Treating Physician',
                            value: 'Dr. ${r.doctorName}',
                          ),
                        ),
                        context.horizontalSpace(12),
                      ],
                      Expanded(
                        child: _InfoChip(
                          label: 'Visit Date',
                          value: r.date.length >= 10
                              ? r.date.substring(0, 10)
                              : r.date,
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(20),
                  if (r.type.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.sick_outlined,
                      title: 'Chief Complaint',
                      content: r.type,
                    ),
                    context.verticalSpace(20),
                  ],
                ],
              ),
            ),
          ),
          CustomButton(
            text: 'Download Pdf',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download feature coming soon')),
            ),
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            height: 48,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ReportImage extends StatelessWidget {
  final String? imageUrl;
  final String status;

  const _ReportImage({this.imageUrl, required this.status});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.r(16)),
          child: NetworkImageWithFallback(
            imageUrl: imageUrl,
            height: context.h(200),
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: context.r(16),
            fallback: _defaultImg(context),
          ),
        ),
        Positioned(
          top: context.h(12),
          right: context.w(12),
          child: _StatusBadge(status: status),
        ),
      ],
    );
  }

  Widget _defaultImg(BuildContext context) {
    return Container(
      height: context.h(200),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE07B5A).withOpacity(0.7),
            const Color(0xFFE07B5A).withOpacity(0.3),
            Colors.white.withOpacity(0.9),
            const Color(0xFFE07B5A).withOpacity(0.5),
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(context.r(16)),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.show_chart_rounded,
            size: context.sp(52),
            color: const Color(0xFFE07B5A).withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'normal':
      case 'active':
      case 'completed':
        textColor = Colors.green.shade700;
        bgColor = Colors.green.shade50;
        break;
      case 'abnormal':
        textColor = Colors.red.shade700;
        bgColor = Colors.red.shade50;
        break;
      default:
        textColor = Colors.orange.shade700;
        bgColor = Colors.orange.shade50;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.w(14), vertical: context.h(6)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.r(30)),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: context.sp(12),
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.w(12), vertical: context.h(10)),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(context.r(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: context.sp(11), color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final dynamic metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final pct = (metric.value as num).toDouble().clamp(0.0, 100.0);
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
              Expanded(
                child: Text(metric.name,
                    style: AppTextStyles.semiBold16Black
                        .copyWith(color: AppColors.primary)),
              ),
              Text(
                '${metric.value}${metric.unit}',
                style: AppTextStyles.semiBold16Black.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700),
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
            'Within normal range ${metric.range}',
            style: AppTextStyles.semiBold16Black
                .copyWith(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
