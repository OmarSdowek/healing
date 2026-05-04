import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/route/routes.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../appointment/presentation/manger/appointment_cubit.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import 'appointment_card.dart';

class UpcomingAppointmentSection extends StatelessWidget {
  const UpcomingAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes and rebuild appointment section accordingly
    return BlocBuilder<PatientAuthCubit, PatientAuthState>(
      builder: (context, authState) {
        int patientId = 1;
        if (authState is PatientDataSuccess) {
          patientId = int.tryParse(authState.meData.patientId ?? '1') ?? 1;
          print("✅ UpcomingAppointmentSection: Patient ID = $patientId");
        }

        return BlocProvider(
          key: ValueKey(patientId), // Recreate when patientId changes
          create: (_) {
            print("🔥 UpcomingAppointmentSection: Creating AppointmentCubit with patientId=$patientId");
            return sl<AppointmentCubit>()..loadAppointments(patientId);
          },
          child: BlocBuilder<AppointmentCubit, AppointmentState>(
            builder: (context, state) {
              print("🔥 UpcomingAppointmentSection: state = ${state.runtimeType}");

              if (state is AppointmentLoading) {
                return const SizedBox(); // Silent loading
              }

              if (state is AppointmentError) {
                print("❌ UpcomingAppointmentSection Error: ${state.message}");
                return const SizedBox(); // Don't break home UI
              }

              if (state is AppointmentLoaded) {
                final upcomingAppointments = state.appointments
                    .where((apt) =>
                        apt.status == 'Scheduled' ||
                        apt.status == 'Confirmed' ||
                        apt.status == 'Pending')
                    .toList();

                print("✅ UpcomingAppointmentSection: ${upcomingAppointments.length} upcoming");

                if (upcomingAppointments.isEmpty) {
                  return const SizedBox();
                }

                final appointment = upcomingAppointments.first;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Upcoming Appointment",
                            style: AppTextStyles.reg20black),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.upComingOppointment);
                          },
                          child: Text(
                            "View all",
                            style: AppTextStyles.semiBold16Black.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppointmentCard(
                      date:
                          "${appointment.appointmentDate} – ${appointment.startTime}",
                      doctorName: appointment.doctorName,
                      speciality: appointment.doctorSpecialization,
                      image: AssetsManger.doctor2Image,
                      onCancel: () {
                        _showCancelDialog(context, appointment.id);
                      },
                      onReschedule: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Reschedule feature coming soon!"),
                          ),
                        );
                      },
                      status: AppointmentStatus.upcoming,
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
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
