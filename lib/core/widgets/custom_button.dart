import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/constant/app_text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? context.h(50),
      child: outlined
          ? OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.semiBold16Black.copyWith(
            color: textColor ?? AppColors.primaryDark,
          ),
        ),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.semiBold16Black.copyWith(
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}