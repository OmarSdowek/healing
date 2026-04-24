import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

class DoctorFaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onToggle;

  const DoctorFaqItem({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.h(6)),
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// السؤال + زر التوسيع
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(question, style: AppTextStyles.semiBold16Black),
              ),
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.remove : Icons.add,
                  color: AppColors.primary,
                ),
                onPressed: onToggle,
              ),
            ],
          ),

          /// الإجابة لو Expanded
          if (isExpanded) ...[
            SizedBox(height: context.h(8)),
            Text(
              answer,
              style: AppTextStyles.semiBold16Black.copyWith(
                color: AppColors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
