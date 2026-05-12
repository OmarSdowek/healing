import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

class CustomHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;

  const CustomHeader({
    super.key,
    this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(14),
        vertical: context.h(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.black,size: context.sp(30),),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          context.horizontalSpace(20),
          if (title != null)
            Text(
              title!,
              style: AppTextStyles.reg20black.copyWith(color: AppColors.black),
            ),
        ],
      ),
    );
  }
}