import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

class SpecialityCard extends StatelessWidget {
  final String title;
  final String iconPath;
  const SpecialityCard({super.key, required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(45),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// أيقونة التخصص
          Image.asset(iconPath, height: 22, width: 22),

          const SizedBox(width: 8),

          /// اسم التخصص
          Text(
            title,
            style: AppTextStyles.semiBold16Black,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
