import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';

class LogoutDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// العنوان
            Text(
              title,
              style: AppTextStyles.reg20black,
            ),
            context.verticalSpace(12),

            Divider(),

            context.verticalSpace(12),

            /// النص
            Text(
              subtitle,
              style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),

            context.verticalSpace(20),

            /// زرارين Cancel / Logout
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Cancel",
                    onPressed: onCancel,
                    height: 40,
                    width: context.screenWidth,
                    outlined: true,
                    textColor: AppColors.primary,
                  ),
                ),
                context.verticalSpace(15),
                Expanded(
                  child: CustomButton(
                    text: "Logout",
                    onPressed: onConfirm,
                    height: 40,
                    width: context.screenWidth,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
