import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';

class TodayAppointmentsScreen extends StatelessWidget {
  const TodayAppointmentsScreen({super.key});

  static const _appointments = [
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
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(title: "Today Appointment"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(8),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
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
                      // Table header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
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
                      // Rows
                      Expanded(
                        child: ListView.separated(
                          itemCount: _appointments.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final a = _appointments[index];
                            return _AppointmentRow(
                              time: a["time"]!,
                              name: a["name"]!,
                              type: a["type"]!,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 50,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
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
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Color(0xFFFFC107), size: 8),
                const SizedBox(width: 4),
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
