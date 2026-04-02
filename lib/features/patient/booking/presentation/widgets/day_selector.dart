import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

class DaySelector extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const DaySelector({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select A Day", style: AppTextStyles.semiBold24dark.copyWith(color: AppColors.black)),
        context.verticalSpace(10),
        Container(
          padding: EdgeInsets.all(context.r(12)),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(context.r(12)),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3)),
            ],
          ),
          child: TableCalendar(
            key: UniqueKey(),
            firstDay: DateTime.utc(DateTime.now().year, 1, 1),
            lastDay: DateTime.utc(DateTime.now().year, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: onDaySelected,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
          ),
        ),
      ],
    );
  }
}