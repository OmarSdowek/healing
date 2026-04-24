import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';

class TodayAppointmentSection extends StatelessWidget {
  const TodayAppointmentSection({super.key});

  static const _appointments = [
    {"time": "09:00\nAM", "name": "Sarah Ahmed", "type": "Follow-up"},
    {"time": "10:00\nAM", "name": "Mohamed Ahmed", "type": "Consultion"},
    {"time": "01:00\nAM", "name": "Menna Ziad", "type": "Follow-up"},
    {"time": "11:15\nAM", "name": "Eman Reda", "type": "Follow-up"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: "Today Appointment",
          onViewAll: () =>
              Navigator.pushNamed(context, Routes.todayAppointments),
        ),
        context.verticalSpace(10),
        Container(
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(10),
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
              ..._appointments.map(
                (a) => _AppointmentRow(
                  time: a["time"]!,
                  name: a["name"]!,
                  type: a["type"]!,
                ),
              ),
            ],
          ),
        ),
      ],
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.semiBold24dark.copyWith(
            color: AppColors.primaryText,
            fontSize: context.sp(18),
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
    );
  }
}
