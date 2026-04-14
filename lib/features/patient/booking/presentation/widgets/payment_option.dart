import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

class PaymentOption extends StatelessWidget {
  final String title;
  final List<String> icons;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOption({
    required this.title,
    required this.icons,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.h(8)),
        padding: EdgeInsets.all(context.r(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.r(12)),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),

            context.horizontalSpace(10),

            Text(title, style: AppTextStyles.reg20black),

            const Spacer(),

            Row(
              children: icons
                  .map((icon) => Padding(
                padding: EdgeInsets.only(left: context.w(8)),
                child: Image.asset(icon, height: context.h(24)),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}