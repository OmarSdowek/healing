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
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.black,size: context.sp(30),),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          context.horizontalSpace(30),
          if (title != null)
            Text(
              title!,
              style: AppTextStyles.semiBold24dark.copyWith(color: AppColors.black),
            ),
        ],
      ),
    );
  }
}