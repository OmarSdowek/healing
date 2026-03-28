import 'package:flutter/material.dart';
import 'package:healing/features/patient/home/presentation/widgets/specility_card.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

class SpecialitiesSection extends StatelessWidget {
  final List<Map<String, String>> specialities;
  const SpecialitiesSection({super.key, required this.specialities});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔹 Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Specialities",
                style: AppTextStyles.semiBold24dark.copyWith(
                  color: AppColors.black,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View all",
                  style: AppTextStyles.semiBold16Black.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// 🔹 Cards
        SizedBox(
          height: 50, // مهم علشان الكروت تبان مظبوطة
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, i) => SpecialityCard(
              title: specialities[i]["title"]!,
              iconPath: specialities[i]["icon"]!,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: specialities.length,
          ),
        ),
      ],
    );
  }
}
