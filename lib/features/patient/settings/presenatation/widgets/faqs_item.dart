import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onToggle;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
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
                child: Text(
                  question,
                  style: AppTextStyles.semiBold16Black,
                ),
              ),
              IconButton(
                icon: Icon(isExpanded ? Icons.remove : Icons.add,
                    color: AppColors.primary),
                onPressed: onToggle,
              ),
            ],
          ),

          /// الإجابة لو Expanded
          if (isExpanded) ...[
            const SizedBox(height: 8),
            Text(
              answer,
              style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
