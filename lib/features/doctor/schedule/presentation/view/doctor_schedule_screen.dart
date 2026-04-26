import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../cubit/doctor_schedule_cubit.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorScheduleCubit>().loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(title: "Doctor Schedule"),
            Expanded(
              child: BlocBuilder<DoctorScheduleCubit, DoctorScheduleState>(
                builder: (context, state) {
                  if (state is DoctorScheduleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorScheduleError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          SizedBox(height: context.h(16)),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: context.h(16)),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<DoctorScheduleCubit>()
                                  .loadSchedules();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is DoctorScheduleLoaded) {
                    if (state.schedules.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: context.h(16)),
                            const Text('No schedules available'),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(20),
                        vertical: context.h(12),
                      ),
                      itemCount: state.schedules.length,
                      separatorBuilder: (_, __) => context.verticalSpace(16),
                      itemBuilder: (context, index) {
                        final schedule = state.schedules[index];
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(context.w(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schedule.dayOfWeek ?? 'N/A',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                SizedBox(height: context.h(8)),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16),
                                    SizedBox(width: context.w(8)),
                                    Text(
                                      '${schedule.startTime} - ${schedule.endTime}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                SizedBox(height: context.h(8)),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.w(8),
                                        vertical: context.h(4),
                                      ),
                                      decoration: BoxDecoration(
                                        color: schedule.isActive == true
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        schedule.isActive == true
                                            ? 'Active'
                                            : 'Inactive',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: schedule.isActive == true
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
