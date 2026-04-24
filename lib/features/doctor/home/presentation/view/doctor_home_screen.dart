import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/network/token_storage.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/data/repo/doctor_appointments_repo_impl.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/complete_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/confirm_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/get_doctor_appointments_use_case.dart';
import 'package:healing/features/doctor/appointments/presentation/manger/doctor_appointments_cubit.dart';
import 'package:healing/features/doctor/home/presentation/widgets/appointment_card.dart';
import 'package:healing/features/doctor/home/presentation/widgets/doctor_home_header.dart';
import 'package:healing/features/doctor/home/presentation/widgets/today_appointment_section.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = context.w(
      context.orientation == Orientation.landscape ? 40 : 20,
    );

    return FutureBuilder<String?>(
      future: TokenStorage.getDoctorId(),
      builder: (context, snap) {
        final doctorId = int.tryParse(snap.data ?? '') ?? 1;
        return BlocProvider(
          create: (_) {
            final repo = DoctorAppointmentsRepoImpl(ApiService());
            return DoctorAppointmentsCubit(
              GetDoctorAppointmentsUseCase(repo),
              ConfirmAppointmentUseCase(repo),
              CompleteAppointmentUseCase(repo),
            )..loadAppointments(doctorId: doctorId);
          },
          child: Scaffold(
            body: SafeArea(
              child:
                  BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
                    builder: (context, state) {
                      final all = state is DoctorAppointmentsLoaded
                          ? state.appointments
                          : <AppointmentModel>[];

                      final upcoming = _filterUpcoming(all);
                      final recent = _filterRecent(all);

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            context.verticalSpace(16),
                            FutureBuilder<String?>(
                              future: TokenStorage.getDoctorId(),
                              builder: (_, __) => const DoctorHomeHeader(
                                name: "Dr. Reham",
                                imageAsset: AssetsManger.doctorImage,
                              ),
                            ),
                            context.verticalSpace(24),

                            // Today table — uses its own static/API data
                            const TodayAppointmentSection(),
                            context.verticalSpace(24),

                            // Upcoming
                            if (state is DoctorAppointmentsLoading)
                              const Center(child: CircularProgressIndicator())
                            else ...[
                              _AppointmentListSection(
                                title: "Upcoming Appointment",
                                onViewAll: () => Navigator.pushNamed(
                                  context,
                                  Routes.doctorSchedule,
                                ),
                                cards: upcoming.isEmpty
                                    ? [_fallbackCard(context, isUpcoming: true)]
                                    : upcoming
                                          .map(
                                            (a) => _buildCard(
                                              context,
                                              a,
                                              isUpcoming: true,
                                            ),
                                          )
                                          .toList(),
                              ),
                              context.verticalSpace(24),
                              _AppointmentListSection(
                                title: "Recent Appointment",
                                onViewAll: () {},
                                cards: recent.isEmpty
                                    ? [
                                        _fallbackCard(
                                          context,
                                          isUpcoming: false,
                                        ),
                                      ]
                                    : recent
                                          .map(
                                            (a) => _buildCard(
                                              context,
                                              a,
                                              isUpcoming: false,
                                            ),
                                          )
                                          .toList(),
                              ),
                            ],
                            context.verticalSpace(24),
                          ],
                        ),
                      );
                    },
                  ),
            ),
          ),
        );
      },
    );
  }

  List<AppointmentModel> _filterUpcoming(List<AppointmentModel> all) {
    final now = DateTime.now();
    return all
        .where((a) {
          try {
            return DateTime.parse(a.appointmentDate).isAfter(now) &&
                (a.status == 'Scheduled' || a.status == 'Confirmed');
          } catch (_) {
            return false;
          }
        })
        .take(3)
        .toList();
  }

  List<AppointmentModel> _filterRecent(List<AppointmentModel> all) {
    return all.where((a) => a.status == 'Completed').take(3).toList();
  }

  Widget _buildCard(
    BuildContext context,
    AppointmentModel a, {
    required bool isUpcoming,
  }) {
    return AppointmentCard(
      date: "${a.appointmentDate}  ${a.startTime}",
      patientName: a.patient.fullName,
      age: 0,
      diagnosis: a.reasonForVisit,
      patientImage: AssetsManger.person,
      statusLabel: isUpcoming ? "Next Appointment" : "Completed",
      statusColor: isUpcoming ? const Color(0xFF7C3AED) : Colors.green,
      onAddPrescription: () => Navigator.pushNamed(
        context,
        Routes.addPrescription,
        arguments: {
          'patientName': a.patient.fullName,
          'patientAge': 0,
          'patientMrn': a.patient.medicalRecordNumber,
          'patientBloodType': 'N/A',
          'patientWeight': 'N/A',
          'patientImage': AssetsManger.person,
        },
      ),
      onOpenRecord: () {},
    );
  }

  Widget _fallbackCard(BuildContext context, {required bool isUpcoming}) {
    return AppointmentCard(
      date: isUpcoming
          ? "Monday, July 21 - 11:00 Am"
          : "Monday, July 21 - 9:00 Am",
      patientName: isUpcoming ? "Mohamed Ahmed" : "Sayed Ahmed",
      age: isUpcoming ? 22 : 50,
      diagnosis: "Influenza",
      patientImage: AssetsManger.person,
      statusLabel: isUpcoming ? "Next Appointment" : "Completed",
      statusColor: isUpcoming ? const Color(0xFF7C3AED) : Colors.green,
      onAddPrescription: () {},
      onOpenRecord: () {},
    );
  }
}

class _AppointmentListSection extends StatelessWidget {
  final String title;
  final List<Widget> cards;
  final VoidCallback onViewAll;

  const _AppointmentListSection({
    required this.title,
    required this.cards,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semiBold24dark.copyWith(
                  color: AppColors.primaryText,
                  fontSize: context.sp(18),
                ),
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                "View All",
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: AppColors.primary,
                  fontSize: context.sp(14),
                ),
              ),
            ),
          ],
        ),
        context.verticalSpace(12),
        ...cards,
      ],
    );
  }
}
