import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';



void showConfirmationDialog(
  BuildContext context,
  String doctorName,
  DateTime appointmentDate,
) {
  final monthName = _monthName(appointmentDate.month);
  final day = appointmentDate.day;
  final year = appointmentDate.year;
  final time = _formatTime(appointmentDate);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            context.verticalSpace(12),

            Text(
              "Congratulations!",
              style: AppTextStyles.semiBold24dark.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your appointment with Dr. $doctorName is\n confirmed for $monthName $day, $year at $time.",
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold16Black,
            ),
            context.verticalSpace(20),

            CustomButton(
              text: "Done",
              outlined: false,
              backgroundColor: AppColors.primary,
              onPressed: () {},
            ),
            context.verticalSpace(12),
            CustomButton(
              text: "Edit your appointment",
              outlined: true,
              onPressed: () {},
              textColor: AppColors.primary,
            ),
          ],
        ),
      );
    },
  );
}

String _monthName(int month) {
  const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return months[month - 1];
}

String _formatTime(DateTime date) {
  final hour = date.hour > 12 ? date.hour - 12 : date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? "PM" : "AM";
  return "$hour:$minute $suffix";
}
