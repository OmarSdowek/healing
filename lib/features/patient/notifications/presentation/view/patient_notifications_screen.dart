import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';

class PatientNotificationsScreen extends StatelessWidget {
  const PatientNotificationsScreen({super.key});

  static const _notifications = [
    {
      "type": "upcoming",
      "title": "Upcoming Appointment",
      "body": "Reminder: You have an appointment with...",
      "time": "1h",
    },
    {
      "type": "upcoming",
      "title": "Upcoming Appointment",
      "body": "Reminder: You have an appointment with...",
      "time": "2h",
    },
    {
      "type": "upcoming",
      "title": "Upcoming Appointment",
      "body": "Reminder: You have an appointment with...",
      "time": "5h",
    },
    {
      "type": "cancelled",
      "title": "Appointment Cancelled",
      "body":
          "You have successfully cancelled your appointment with Ahmed Yasser.",
      "time": "3d",
    },
    {
      "type": "cancelled",
      "title": "Appointment Cancelled",
      "body":
          "You have successfully cancelled your appointment with Bassant Kamel.",
      "time": "5d",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(title: "Notification"),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(8),
              ),
              child: Text(
                "Today",
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: AppColors.primary,
                  fontSize: context.sp(15),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => context.verticalSpace(10),
                itemBuilder: (context, index) {
                  final n = _notifications[index];
                  final isUpcoming = n["type"] == "upcoming";
                  return _NotificationTile(
                    title: n["title"]!,
                    body: n["body"]!,
                    time: n["time"]!,
                    isUpcoming: isUpcoming,
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

class _NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isUpcoming;

  const _NotificationTile({
    required this.title,
    required this.body,
    required this.time,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final iconBg = isUpcoming
        ? AppColors.primary.withOpacity(0.12)
        : const Color(0xFFFFE5E5);
    final iconColor = isUpcoming ? AppColors.primary : const Color(0xFFE53935);
    final icon = isUpcoming
        ? Icons.access_time_rounded
        : Icons.event_busy_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.w(42),
            height: context.h(42),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: context.sp(22)),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.semiBold16Black.copyWith(
                    fontSize: context.sp(14),
                    color: AppColors.primaryText,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  body,
                  style: AppTextStyles.semiBold16Black.copyWith(
                    fontSize: context.sp(12),
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          context.horizontalSpace(8),
          Text(
            time,
            style: AppTextStyles.semiBold16Black.copyWith(
              fontSize: context.sp(12),
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
