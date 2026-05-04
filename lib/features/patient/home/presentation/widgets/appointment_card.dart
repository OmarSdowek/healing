import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';

enum AppointmentStatus { upcoming, completed, canceled }

class AppointmentCard extends StatelessWidget {
  final String date;
  final String doctorName;
  final String speciality;
  final String? image; // optional — shows Icons.person if null/localhost
  final VoidCallback onCancel;
  final VoidCallback onReschedule;
  final AppointmentStatus status;

  const AppointmentCard({
    super.key,
    required this.date,
    required this.doctorName,
    required this.speciality,
    this.image,
    required this.onCancel,
    required this.onReschedule,
    required this.status,
  });

  Color _statusColor() {
    switch (status) {
      case AppointmentStatus.upcoming:
        return AppColors.primary;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.canceled:
        return Colors.red;
    }
  }

  String _statusText() {
    switch (status) {
      case AppointmentStatus.upcoming:
        return "Upcoming";
      case AppointmentStatus.completed:
        return "Completed";
      case AppointmentStatus.canceled:
        return "Canceled";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.04,
        vertical: context.screenHeight * 0.01,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date + Status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  date.isNotEmpty ? date : '—',
                  style: AppTextStyles.semiBold16Black.copyWith(
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _statusText(),
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: _statusColor(),
                ),
              ),
            ],
          ),
          const Divider(thickness: 1),
          context.verticalSpace(8),

          /// Doctor info
          Row(
            children: [
              /// Always show Icons.person — no asset/network images
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName.isNotEmpty ? doctorName : '—',
                      style: AppTextStyles.semiBold16Black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    context.verticalSpace(4),
                    Text(
                      speciality.isNotEmpty ? speciality : '—',
                      style: AppTextStyles.semiBold16Black
                          .copyWith(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          context.verticalSpace(12),

          /// Buttons (only for upcoming & canceled)
          if (status != AppointmentStatus.completed)
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Cancel",
                    textColor: AppColors.primary,
                    onPressed: onCancel,
                    outlined: true,
                  ),
                ),
                context.horizontalSpace(10),
                Expanded(
                  child: CustomButton(
                    text: "Reschedule",
                    onPressed: onReschedule,
                    outlined: false,
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
