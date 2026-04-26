import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/features/doctor/home/presentation/cubit/doctor_home_cubit.dart';
import 'package:healing/features/doctor/home/presentation/cubit/doctor_home_cubit_factory.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = DoctorHomeCubitFactory.create();
        cubit.loadDashboard();
        return cubit;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
            builder: (context, state) {
              if (state is DoctorHomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DoctorHomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DoctorHomeCubit>().loadDashboard();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is DoctorHomeLoaded) {
                final dashboard = state.dashboard;
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<DoctorHomeCubit>().refreshDashboard(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header
                        Text(
                          "Welcome Back, Doctor",
                          style: AppTextStyles.headline1.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        context.verticalSpace(8),
                        Text(
                          "Here's your today's summary",
                          style: AppTextStyles.reg20black.copyWith(
                            color: AppColors.grey,
                          ),
                        ),

                        context.verticalSpace(24),

                        /// Dashboard Stats
                        Row(
                          children: [
                            _buildStatCard(
                              title: "Today's Appointments",
                              value: dashboard.totalAppointmentsToday ?? 0,
                              color: AppColors.primary,
                              context: context,
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              title: "Confirmed",
                              value: dashboard.confirmedAppointments ?? 0,
                              color: Colors.green,
                              context: context,
                            ),
                          ],
                        ),

                        context.verticalSpace(12),

                        Row(
                          children: [
                            _buildStatCard(
                              title: "Pending",
                              value: dashboard.pendingAppointments ?? 0,
                              color: Colors.orange,
                              context: context,
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              title: "Total Patients",
                              value: dashboard.totalPatients ?? 0,
                              color: Colors.blue,
                              context: context,
                            ),
                          ],
                        ),

                        context.verticalSpace(24),

                        /// Today's Appointments Section
                        Text(
                          "Today's Appointments",
                          style: AppTextStyles.semiBold24dark.copyWith(
                            color: AppColors.black,
                          ),
                        ),

                        context.verticalSpace(12),

                        if (dashboard.todayAppointments == null ||
                            dashboard.todayAppointments!.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Text(
                                "No appointments today",
                                style: AppTextStyles.reg20black.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dashboard.todayAppointments!.length,
                            itemBuilder: (context, index) {
                              final appointment =
                                  dashboard.todayAppointments![index];
                              return _buildAppointmentCard(
                                appointment: appointment,
                                context: context,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required Color color,
    required BuildContext context,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.semiBold16Black.copyWith(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
            context.verticalSpace(8),
            Text(
              value.toString(),
              style: AppTextStyles.headline1.copyWith(
                color: color,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required dynamic appointment,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName ?? "Patient",
                      style: AppTextStyles.semiBold16Black,
                    ),
                    context.verticalSpace(4),
                    Text(
                      appointment.reasonForVisit ?? "No reason provided",
                      style: AppTextStyles.reg20black.copyWith(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    appointment.status,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.status ?? "Unknown",
                  style: AppTextStyles.semiBold16Black.copyWith(
                    color: _getStatusColor(appointment.status),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          context.verticalSpace(12),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                "${appointment.startTime} - ${appointment.endTime}",
                style: AppTextStyles.reg20black.copyWith(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          context.verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.todayAppointments);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text("View Details"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'scheduled':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.grey;
    }
  }
}
