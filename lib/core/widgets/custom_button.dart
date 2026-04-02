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
  final Widget? icon; // 🔥 بدل IconData

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.outlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? context.h(50),
      child: outlined
          ? OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
        ),
        onPressed: onPressed,
        child: _buildContent(context),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          backgroundColor ?? AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
        ),
        onPressed: onPressed,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 🔥 توسيط
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: 8),
          ],

          Text(
            text,
            style: AppTextStyles.semiBold16Black.copyWith(
              color: textColor ?? Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}