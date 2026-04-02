import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';


class TimeSelector extends StatelessWidget {
  final String selectedTime;
  final Function(String) onSelect;

  const TimeSelector({super.key, required this.selectedTime, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final times = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM","2:00 PM","3:00 PM","4:00 PM"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Time", style: AppTextStyles.reg20black),
        context.verticalSpace(13),
        Wrap(
          spacing: context.w(10),
          runSpacing: context.h(10),
          children: times.map((time) {
            return _TimeSlot(time, selectedTime == time, () => onSelect(time));
          }).toList(),
        ),
      ],
    );
  }
}
class _TimeSlot extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeSlot(this.time, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(10)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(context.r(8)),
        ),
        child: Text(
          time,
          style: AppTextStyles.semiBold16Black.copyWith(
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
