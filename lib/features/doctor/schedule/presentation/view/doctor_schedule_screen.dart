import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/network/token_storage.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/doctor/appointments/data/models/appointment_model.dart';
import 'package:healing/features/doctor/appointments/data/repo/doctor_appointments_repo_impl.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/complete_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/confirm_appointment_use_case.dart';
import 'package:healing/features/doctor/appointments/domin/use_cases/get_doctor_appointments_use_case.dart';
import 'package:healing/features/doctor/appointments/presentation/manger/doctor_appointments_cubit.dart';
import 'package:healing/features/doctor/home/presentation/widgets/appointment_card.dart';

class DoctorScheduleScreen extends StatelessWidget {
  const DoctorScheduleScreen({super.key});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: "Upcoming Appointment"),
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
                              return _StaticList(hPad: hPad);
                            }

                            final upcoming = state is DoctorAppointmentsLoaded
                                ? state.appointments
                                      .where(
                                        (a) =>
                                            a.status == 'Scheduled' ||
                                            a.status == 'Confirmed',
                                      )
                                      .toList()
                                : <AppointmentModel>[];

                            if (upcoming.isEmpty) {
                              return _StaticList(hPad: hPad);
                            }

                            return ListView.separated(
                              padding: EdgeInsets.symmetric(
                                horizontal: hPad,
                                vertical: context.h(12),
                              ),
                              itemCount: upcoming.length,
                              separatorBuilder: (_, __) =>
                                  context.verticalSpace(16),
                              itemBuilder: (context, i) {
                                final a = upcoming[i];
                                return AppointmentCard(
                                  date: "${a.appointmentDate}  ${a.startTime}",
                                  patientName: a.patient.fullName,
                                  age: 0,
                                  diagnosis: a.reasonForVisit,
                                  patientImage: AssetsManger.person,
                                  statusLabel: "Next Appointment",
                                  statusColor: const Color(0xFF7C3AED),
                                  onAddPrescription: () => Navigator.pushNamed(
                                    context,
                                    Routes.addPrescription,
                                    arguments: {
                                      'patientName': a.patient.fullName,
                                      'patientAge': 0,
                                      'patientMrn':
                                          a.patient.medicalRecordNumber,
                                      'patientBloodType': 'N/A',
                                      'patientWeight': 'N/A',
                                      'patientImage': AssetsManger.person,
                                    },
                                  ),
                                  onOpenRecord: () {},
                                );
                              },
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StaticList extends StatelessWidget {
  final double hPad;
  const _StaticList({required this.hPad});

  static const _items = [
    {
      "date": "Monday, July 21 - 10:00 Am",
      "name": "Mohamed Ahmed",
      "age": 22,
      "diagnosis": "Influenza",
    },
    {
      "date": "Monday, July 21 - 11:00 Am",
      "name": "Menna Ziad",
      "age": 18,
      "diagnosis": "Influenza",
    },
    {
      "date": "Monday, July 21 - 12:00 Am",
      "name": "Eman Reda",
      "age": 32,
      "diagnosis": "Influenza",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: context.h(12)),
      itemCount: _items.length,
      separatorBuilder: (_, __) => context.verticalSpace(16),
      itemBuilder: (context, i) {
        final a = _items[i];
        return AppointmentCard(
          date: a["date"] as String,
          patientName: a["name"] as String,
          age: a["age"] as int,
          diagnosis: a["diagnosis"] as String,
          patientImage: AssetsManger.person,
          statusLabel: "Next Appointment",
          statusColor: const Color(0xFF7C3AED),
          onAddPrescription: () => Navigator.pushNamed(
            context,
            Routes.addPrescription,
            arguments: {
              'patientName': a["name"] as String,
              'patientAge': a["age"] as int,
              'patientMrn': '#MRN-29384',
              'patientBloodType': 'O+',
              'patientWeight': '78KG',
              'patientImage': AssetsManger.person,
            },
          ),
          onOpenRecord: () {},
        );
      },
    );
  }
}
