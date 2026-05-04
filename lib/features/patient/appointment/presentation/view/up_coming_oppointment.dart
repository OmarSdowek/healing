import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../../home/presentation/widgets/appointment_card.dart';
import '../manger/appointment_cubit.dart';

class UpComingOppointment extends StatelessWidget {
  const UpComingOppointment({super.key});

  @override
  Widget build(BuildContext context) {
    // Try to get PatientAuthCubit from ancestor (IndexedStack in MainScreen)
    // If not available, create our own
    PatientAuthCubit? existingCubit;
    try {
      existingCubit = context.read<PatientAuthCubit>();
    } catch (_) {
      existingCubit = null;
    }

    if (existingCubit != null) {
      return _buildWithAuthState(context, existingCubit.state);
    }

    // Standalone mode (navigated via route)
    return BlocProvider<PatientAuthCubit>(
      create: (_) => sl<PatientAuthCubit>()..meData(),
      child: BlocBuilder<PatientAuthCubit, PatientAuthState>(
        builder: (ctx, authState) => _buildWithAuthState(ctx, authState),
      ),
    );
  }

  Widget _buildWithAuthState(BuildContext context, PatientAuthState authState) {
    int patientId = 1;
    if (authState is PatientDataSuccess) {
      patientId = int.tryParse(authState.meData.patientId ?? '1') ?? 1;
      print("✅ UpComingOppointment: Patient ID = $patientId");
    }

    return BlocProvider<AppointmentCubit>(
      key: ValueKey('upcoming_$patientId'),
      create: (_) => sl<AppointmentCubit>()..loadAppointments(patientId),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CustomHeader(title: "Upcoming Appointments"),
                context.verticalSpace(20),
                Expanded(
                  child: BlocBuilder<AppointmentCubit, AppointmentState>(
                    builder: (context, state) {
                      if (state is AppointmentLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is AppointmentError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 12),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red.shade700),
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
                        );
                      }

                      if (state is AppointmentLoaded) {
                        if (state.appointments.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  "No upcoming appointments",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = state.appointments[index];
                            return AppointmentCard(
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
                                    content: Text(
                                        "Reschedule feature coming soon!"),
                                  ),
                                );
                              },
                              status: _mapStatus(appointment.status),
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

  AppointmentStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'scheduled':
      case 'pending':
        return AppointmentStatus.upcoming;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
      case 'canceled':
        return AppointmentStatus.canceled;
      default:
        return AppointmentStatus.upcoming;
    }
  }

  void _showCancelDialog(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content: const Text(
            "Are you sure you want to cancel this appointment?"),
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
