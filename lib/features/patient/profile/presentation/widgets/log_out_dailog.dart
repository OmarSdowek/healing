import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String subtitle;
  final String btnText;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.subtitle,
    required this.btnText
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.r(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(context.r(16)),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, color: Colors.white, size: 32),
            ),
            context.verticalSpace(20),

            /// النص
            Text(
              subtitle,
              style: AppTextStyles.reg20black,
              textAlign: TextAlign.center,
            ),
            context.verticalSpace(25),

            /// زرارين Cancel / Logout
            Column(
              children: [
                CustomButton(
                  text: btnText,
                  onPressed: onConfirm,
                  height: context.h(45),
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                ),
                context.verticalSpace(12),
                CustomButton(
                  text: "Cancel",
                  onPressed: onCancel,
                  height: context.h(45),
                  outlined: true,
                  textColor: AppColors.primary,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
