import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../../home/presentation/widgets/appointment_card.dart';
import '../manger/appointment_cubit.dart';

class MyAppointment extends StatelessWidget {
  const MyAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientAuthCubit>(
      create: (_) => sl<PatientAuthCubit>()..meData(),
      child: Builder(
        builder: (ctx) {
          return BlocBuilder<PatientAuthCubit, PatientAuthState>(
            builder: (ctx2, authState) {
              int patientId = 1;
              if (authState is PatientDataSuccess) {
                patientId =
                    int.tryParse(authState.meData.patientId ?? '1') ?? 1;
              }

              return BlocProvider<AppointmentCubit>(
                key: ValueKey(patientId),
                create: (_) =>
                    sl<AppointmentCubit>()..loadAppointments(patientId),
                child: Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomHeader(title: "My Appointments"),
                          context.verticalSpace(20),

                          BlocBuilder<AppointmentCubit, AppointmentState>(
                            builder: (context, state) {
                              if (state is AppointmentLoading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is AppointmentError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.error_outline,
                                            size: 64, color: Colors.red),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Failed to load appointments",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red.shade900,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          state.message,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.red.shade700),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<AppointmentCubit>()
                                                .loadAppointments(patientId);
                                          },
                                          child: const Text("Retry"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (state is AppointmentLoaded) {
                                final allAppointments = state.appointments;

                                final upcoming = allAppointments
                                    .where((apt) =>
                                        apt.status == 'Scheduled' ||
                                        apt.status == 'Confirmed' ||
                                        apt.status == 'Pending')
                                    .toList();

                                final completed = allAppointments
                                    .where(
                                        (apt) => apt.status == 'Completed')
                                    .toList();

                                final canceled = allAppointments
                                    .where((apt) =>
                                        apt.status == 'Cancelled' ||
                                        apt.status == 'Canceled')
                                    .toList();

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    /// Upcoming Section
                                    if (upcoming.isNotEmpty) ...[
                                      Text("Upcoming",
                                          style: AppTextStyles.reg20black
                                              .copyWith(
                                                  color: AppColors.primary)),
                                      context.verticalSpace(10),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: upcoming.length,
                                        itemBuilder: (context, index) {
                                          final apt = upcoming[index];
                                          return AppointmentCard(
                                            date:
                                                "${apt.appointmentDate} – ${apt.startTime}",
                                            doctorName: apt.doctorName,
                                            speciality:
                                                apt.doctorSpecialization,
                                            image: AssetsManger.doctor3Image,
                                            onCancel: () {
                                              _showCancelDialog(
                                                  context, apt.id);
                                            },
                                            onReschedule: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Reschedule feature coming soon!"),
                                                ),
                                              );
                                            },
                                            status:
                                                AppointmentStatus.upcoming,
                                          );
                                        },
                                      ),
                                      context.verticalSpace(20),
                                    ],

                                    /// Completed Section
                                    if (completed.isNotEmpty) ...[
                                      Text("Completed",
                                          style: AppTextStyles.reg20black
                                              .copyWith(
                                                  color: Colors.green)),
                                      context.verticalSpace(10),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: completed.length,
                                        itemBuilder: (context, index) {
                                          final apt = completed[index];
                                          return AppointmentCard(
                                            date:
                                                "${apt.appointmentDate} – ${apt.startTime}",
                                            doctorName: apt.doctorName,
                                            speciality:
                                                apt.doctorSpecialization,
                                            image: AssetsManger.doctorImage,
                                            onCancel: () {},
                                            onReschedule: () {},
                                            status:
                                                AppointmentStatus.completed,
                                          );
                                        },
                                      ),
                                      context.verticalSpace(20),
                                    ],

                                    /// Canceled Section
                                    if (canceled.isNotEmpty) ...[
                                      Text("Canceled",
                                          style: AppTextStyles.reg20black
                                              .copyWith(color: Colors.red)),
                                      context.verticalSpace(10),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: canceled.length,
                                        itemBuilder: (context, index) {
                                          final apt = canceled[index];
                                          return AppointmentCard(
                                            date:
                                                "${apt.appointmentDate} – ${apt.startTime}",
                                            doctorName: apt.doctorName,
                                            speciality:
                                                apt.doctorSpecialization,
                                            image: AssetsManger.doctor2Image,
                                            onCancel: () {},
                                            onReschedule: () {},
                                            status:
                                                AppointmentStatus.canceled,
                                          );
                                        },
                                      ),
                                    ],

                                    /// Empty State
                                    if (upcoming.isEmpty &&
                                        completed.isEmpty &&
                                        canceled.isEmpty)
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(40.0),
                                          child: Column(
                                            children: [
                                              Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 64,
                                                  color: Colors.grey.shade400),
                                              const SizedBox(height: 16),
                                              Text(
                                                "No appointments yet",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content:
            const Text("Are you sure you want to cancel this appointment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<AppointmentCubit>()
                  .cancelAppointment(appointmentId, "Patient cancelled");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Appointment cancelled successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );
  }
}
