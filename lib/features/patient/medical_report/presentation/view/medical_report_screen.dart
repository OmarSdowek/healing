import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../manger/medical_report_cubit.dart';
import '../widgets/medical_card.dart';
import 'medical_report_details.dart';

class MedicalReportListScreen extends StatelessWidget {
  const MedicalReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        int patientId = 1;
        try {
          final authState = context.read<PatientAuthCubit>().state;
          if (authState is PatientDataSuccess) {
            patientId =
                int.tryParse(authState.meData.patientId ?? '1') ?? 1;
          }
        } catch (_) {}
        return sl<MedicalReportCubit>()..loadReports(patientId);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.r(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: "Medical report"),
                context.verticalSpace(20),
                Expanded(
                  child: BlocBuilder<MedicalReportCubit, MedicalReportState>(
                    builder: (context, state) {
                      if (state is MedicalReportLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (state is MedicalReportError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 12),
                              Text(state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red.shade700)),
                            ],
                          ),
                        );
                      }

                      if (state is MedicalReportsLoaded) {
                        if (state.reports.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.description_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  "No medical reports yet",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.reports.length,
                          itemBuilder: (context, i) {
                            final report = state.reports[i];
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: context.h(16)),
                              child: ReportCard(
                                reportId: report.id,
                                title: report.title,
                                type: report.type,
                                status: report.status,
                                date: report.date,
                                thumbnailUrl: report.thumbnailUrl,
                                onView: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MedicalReportDetailScreen(
                                        reportId: report.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
