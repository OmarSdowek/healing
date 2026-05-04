import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

class DepartmentChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const DepartmentChip({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          name,
          style: AppTextStyles.semiBold16Black.copyWith(
            fontSize: 14,
            color: isSelected ? Colors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
