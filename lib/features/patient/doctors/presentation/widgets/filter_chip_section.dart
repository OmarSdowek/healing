import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

class FilterChipSection extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final Function(String) onSelected;

  const FilterChipSection({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: filters.map((f) {
        final isSelected = f == selected;
        return ChoiceChip(
          label: Text(f),
          selected: isSelected,
          onSelected: (_) => onSelected(f),
          selectedColor: AppColors.primary.withOpacity(0.2),
        );
      }).toList(),
    );
  }
}
