import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';

Widget showConfirmationDialog(
    BuildContext context,
    String doctorName,
    String speciality,
    DateTime appointmentDate,
    String fees,
    String paymentMethod,
    ) {
  final monthName = _monthName(appointmentDate.month);
  final day = appointmentDate.day;
  final year = appointmentDate.year;
  final time = _formatTime(appointmentDate);

  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    contentPadding: const EdgeInsets.all(20),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ✅ دائرة فيها أيقونة صح
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
          style: AppTextStyles.semiBold24dark.copyWith(color: Colors.green),
        ),
        context.verticalSpace(8),
        Text("Please review your appointment details",
            style: AppTextStyles.semiBold16Black),
        context.verticalSpace(20),

        _detailRow("Doctor:", "Dr. $doctorName"),
        _detailRow("Speciality:", speciality),
        _detailRow("Date:", "$monthName $day, $year"),
        _detailRow("Time:", time),
        _detailRow("Fees:", "$fees EGP"),
        _detailRow("Payment Method:", paymentMethod),

        context.verticalSpace(20),

        CustomButton(
          text: "Done",
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        context.verticalSpace(12),
        CustomButton(
          text: "Edit your appointment",
          outlined: true,
          textColor: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Widget _detailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(title, style: AppTextStyles.reg20black),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: AppTextStyles.semiBold16Black)),
      ],
    ),
  );
}

String _monthName(int month) {
  const months = [
    "January","February","March","April","May","June",
    "July","August","September","October","November","December",
  ];
  return months[month - 1];
}

String _formatTime(DateTime date) {
  final hour = date.hour > 12 ? date.hour - 12 : date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? "PM" : "AM";
  return "$hour:$minute $suffix";
}
