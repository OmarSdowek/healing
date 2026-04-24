import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/data/repo/doctor_appointments_repo_impl.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/complete_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/confirm_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/get_doctor_appointments_use_case.dart';
import 'package:healing/features/doctor/appointments/presentation/manger/doctor_appointments_cubit.dart';

class TodayAppointmentsScreen extends StatelessWidget {
  const TodayAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repo = DoctorAppointmentsRepoImpl(ApiService());
        return DoctorAppointmentsCubit(
          GetDoctorAppointmentsUseCase(repo),
          ConfirmAppointmentUseCase(repo),
          CompleteAppointmentUseCase(repo),
        )..loadAppointments(
          doctorId: 1,
          date: DateTime.now().toIso8601String().split('T').first,
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: SafeArea(
          child: Column(
            children: [
              const CustomHeader(title: "Today Appointment"),
              Expanded(
                child:
                    BlocBuilder<
                      DoctorAppointmentsCubit,
                      DoctorAppointmentsState
                    >(
                      builder: (context, state) {
                        if (state is DoctorAppointmentsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is DoctorAppointmentsError) {
                          return Center(child: Text(state.message));
                        }
                        final appointments = state is DoctorAppointmentsLoaded
                            ? state.appointments
                            : <AppointmentModel>[];
                        return _AppointmentsTable(appointments: appointments);
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentsTable extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const _AppointmentsTable({required this.appointments});

  static const _static = [
    {"time": "09:00\nAM", "name": "Sarah Ahmed", "type": "Follow-up"},
    {"time": "10:00\nAM", "name": "Mohamed Ahmed", "type": "Consultion"},
    {"time": "01:00\nAM", "name": "Menna Ziad", "type": "Follow-up"},
    {"time": "01:00\nAM", "name": "Menna Ziad", "type": "Follow-up"},
    {"time": "01:00\nAM", "name": "Menna Ziad", "type": "Follow-up"},
    {"time": "01:00\nAM", "name": "Menna Ziad", "type": "Follow-up"},
    {"time": "11:15\nAM", "name": "Eman Reda", "type": "Follow-up"},
  ];

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.orientation == Orientation.landscape;
    final hPad = context.w(isLandscape ? 40 : 20);
    final useApi = appointments.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: context.h(8)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.r(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: context.w(50),
                    child: Text(
                      "Time",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        fontSize: context.sp(13),
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Name",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold16Black.copyWith(
                        fontSize: context.sp(13),
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  Text(
                    "Statue",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      fontSize: context.sp(13),
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: useApi ? appointments.length : _static.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (useApi) {
                    final a = appointments[index];
                    return _AppointmentRow(
                      time: "${a.startTime}\n",
                      name: a.patient.fullName,
                      type: a.type,
                    );
                  }
                  final s = _static[index];
                  return _AppointmentRow(
                    time: s["time"]!,
                    name: s["name"]!,
                    type: s["type"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  final String time;
  final String name;
  final String type;

  const _AppointmentRow({
    required this.time,
    required this.name,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.w(50),
            child: Text(
              time,
              style: AppTextStyles.semiBold16Black.copyWith(
                fontSize: context.sp(12),
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: AppColors.grey,
                  size: context.sp(20),
                ),
                context.horizontalSpace(8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.semiBold16Black.copyWith(
                          fontSize: context.sp(13),
                          color: AppColors.primaryText,
                        ),
                      ),
                      Text(
                        type,
                        style: AppTextStyles.semiBold16Black.copyWith(
                          fontSize: context.sp(11),
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(8),
              vertical: context.h(4),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(context.r(6)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: Color(0xFFFFC107), size: 8),
                SizedBox(width: context.w(4)),
                Text(
                  "WAITING",
                  style: AppTextStyles.semiBold16Black.copyWith(
                    fontSize: context.sp(10),
                    color: const Color(0xFFFFC107),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
